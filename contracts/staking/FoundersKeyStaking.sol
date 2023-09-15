// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "../../interfaces/IFoundersKey.sol";
import "../../interfaces/ISoulboundFoundersKey.sol";

import "@matterlabs/zksync-contracts/l1/contracts/zksync/interfaces/IZkSync.sol";
 

/**
    @title FoundersKeyStaking
    @dev contract for staking Founders Keys and minting/burning SoulboundFoundersKeys
    @notice inherits from ERC721HolderUpgradeable, Initializable, UUPSUpgradeable, OwnableUpgradeable, PausableUpgradeable, ReentrancyGuardUpgradeable
 */

contract FoundersKeyStaking is
    Initializable,
    UUPSUpgradeable,
    ERC721HolderUpgradeable,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{

    //STORAGE===================================================================
    IFoundersKey public FoundersKey;
    ISoulboundFoundersKey public SoulboundFoundersKey;

    address public zkSyncAddress;
    address public zkSyncNaffleContractAddress;

    enum StakingPeriod {
        ONE_MONTH,
        THREE_MONTHS,
        SIX_MONTHS,
        TWELVE_MONTHS
    }

    uint256 public constant ONE_MONTH = 30 days;
    uint256 public constant THREE_MONTHS = 90 days;
    uint256 public constant SIX_MONTHS = 180 days;
    uint256 public constant TWELVE_MONTHS = 365 days;

    struct StakeInfo {
        uint16 nftId;
        uint256 stakedSince;
        StakingPeriod stakingPeriod;
    }

    struct L2MessageParams {
        uint256 l2GasLimit;
        uint256 l2GasPerPubdataByteLimit;
    }

    mapping(uint16 => uint) private nftIdToIndex;
    mapping(address => StakeInfo[]) public userStakeInfo;

    event UserStaked(
        address userAddress,
        uint16 nftId,
        uint256 stakeTime,
        StakingPeriod stakingPeriod
    );
    event UserUnstaked(address userAddress, uint16 nftId, uint256 unstakeTime);

    error NFTAlreadyStaked(uint16 nftId);
    error NFTIsNotStaked(uint16 nftId);
    error NFTLocked(uint16 nftId, uint256 unlockTime);
    error AddressIsZero(address addr);


    //INITIALIZATION===================================================================

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address _foundersKeyAddress,
        address _soulboundFoundersKeyAddress,
        address _zkSyncAddress
    ) public initializer {
        __FoundersKeyStaking_init(
            _foundersKeyAddress,
            _soulboundFoundersKeyAddress
        );
        __Ownable_init();
        __Pausable_init();
        __UUPSUpgradeable_init();

        zkSyncAddress = _zkSyncAddress;
    }

    function __FoundersKeyStaking_init(
        address _foundersKeyAddress,
        address _soulboundFoundersKeyAddress
    ) internal onlyInitializing {
        __FoundersKeyStaking_init_unchained(
            _foundersKeyAddress,
            _soulboundFoundersKeyAddress
        );
    }

    function __FoundersKeyStaking_init_unchained(
        address _foundersKeyAddress,
        address _soulboundFoundersKeyAddress
    ) internal onlyInitializing {
        FoundersKey = IFoundersKey(_foundersKeyAddress);
        SoulboundFoundersKey = ISoulboundFoundersKey(
            _soulboundFoundersKeyAddress
        );
    }
    
    //USER-FACING===================================================================

    /**
        @dev Stakes a FoundersKey NFT for a given period of time and mints the user a SoulboundFoundersKey NFT
        @param _nftId the ID of the NFT to stake
        @param _stakingPeriod the period of time to stake the NFT for
        @dev reverts if the NFT is already staked
        @dev pushes a new StakeInfo struct to the userStakeInfo mapping containing the staked NFT's ID, the time it was staked, and the staking period
     */
    function stake(
        uint16 _nftId,
        StakingPeriod _stakingPeriod,
        L2MessageParams memory _l2MessageParams
    ) external payable whenNotPaused nonReentrant returns (bytes32 txHash) {

        if(nftIdToIndex[_nftId] != 0) {
            revert NFTAlreadyStaked(_nftId);
        }

        StakeInfo memory stakeInfo = StakeInfo(
            _nftId,
            block.timestamp,
            _stakingPeriod
        );

        StakeInfo[] storage stakeInfoArray = userStakeInfo[msg.sender];
        uint index = stakeInfoArray.length;
        stakeInfoArray.push(stakeInfo);
        nftIdToIndex[_nftId] = index;

        // update staking data storage on zksync
        IZkSync zksync = IZkSync(zkSyncAddress);
        bytes memory data = abi.encodeWithSignature(
            "setUserToStakedFoundersKeyIdsToStakeDuration(address, uint256, uint256)",
            msg.sender,
            _nftId,
            _getStakingPeriod(_stakingPeriod)
        );

        txHash = zksync.requestL2Transaction{value: msg.value}(
            zkSyncNaffleContractAddress,
            0,
            data,
            _l2MessageParams.l2GasLimit,
            _l2MessageParams.l2GasPerPubdataByteLimit,
            new bytes[](0),
            msg.sender
        );

        FoundersKey.transferFrom(msg.sender, address(this), _nftId);
        SoulboundFoundersKey.safeMint(msg.sender, _nftId);

        emit UserStaked(msg.sender, _nftId, block.timestamp, _stakingPeriod);
    }

    /**
        @dev Unstakes a FoundersKey NFT and burns the user's SoulboundFoundersKey NFT
        @param _nftId the ID of the NFT to unstake
        @dev reverts if the NFT is not staked or is locked
     */
    function unstake(
        uint16 _nftId,         
        L2MessageParams memory _l2MessageParams
    ) external payable nonReentrant returns (bytes32 txHash) {
        uint index = nftIdToIndex[_nftId];
        StakeInfo[] storage stakeInfoArray = userStakeInfo[msg.sender];
        StakeInfo memory stakeInfo = stakeInfoArray[index];

        if(nftIdToIndex[_nftId] == 0) {
            revert NFTIsNotStaked(_nftId);
        }
        
        if (
            stakeInfo.stakedSince + _getStakingPeriod(stakeInfo.stakingPeriod) >
            block.timestamp
        ) {
            revert NFTLocked(
                _nftId,
                stakeInfo.stakedSince +
                    _getStakingPeriod(stakeInfo.stakingPeriod)
            );
        }

        // Swap with the last element and reduce array size
        stakeInfoArray[index] = stakeInfoArray[stakeInfoArray.length - 1];
        stakeInfoArray.pop();

        // Delete the current index and modify the one that was swapped to reflect the new struct instance
        delete nftIdToIndex[_nftId];
        nftIdToIndex[stakeInfoArray[index].nftId] = index;

        // update staking data storage on zksync - if _stakeDuration 0, triggers deletion of staking data on L2
        IZkSync zksync = IZkSync(zkSyncAddress);
        bytes memory data = abi.encodeWithSignature(
            "setUserToStakedFoundersKeyIdsToStakeDuration(address, uint256, uint256)",
            msg.sender,
            _nftId,
            0
        );

        txHash = zksync.requestL2Transaction{value: msg.value}(
            zkSyncNaffleContractAddress,
            0,
            data,
            _l2MessageParams.l2GasLimit,
            _l2MessageParams.l2GasPerPubdataByteLimit,
            new bytes[](0),
            msg.sender
        );

        SoulboundFoundersKey.burn(_nftId);
        FoundersKey.transferFrom(address(this), msg.sender, _nftId);

        emit UserUnstaked(msg.sender, _nftId, block.timestamp);
    }

    //READS===================================================================
    function _getStakingPeriod(
        StakingPeriod _stakingPeriod
    ) internal pure returns (uint256) {
        if (_stakingPeriod == StakingPeriod.ONE_MONTH) {
            return ONE_MONTH;
        } else if (_stakingPeriod == StakingPeriod.THREE_MONTHS) {
            return THREE_MONTHS;
        } else if (_stakingPeriod == StakingPeriod.SIX_MONTHS) {
            return SIX_MONTHS;
        } else if (_stakingPeriod == StakingPeriod.TWELVE_MONTHS) {
            return TWELVE_MONTHS;
        } else {
            revert("Invalid staking period!");
        }
    }

    function getBestStakedNFTInfo(
        address _userAddress
    ) external view returns (uint8, uint16, uint256) {
        uint8 bestStakedType = 0;
        uint16 amountStakedOfBestType = 0;
        uint256 earliestTimeStakedOfBestType = 0;

        StakeInfo[] memory stakedInfos = userStakeInfo[_userAddress];

        for (uint i = 0; i < stakedInfos.length; ++i) {
            StakeInfo memory stakedInfo = stakedInfos[i];
            uint8 tokenType = FoundersKey.tokenType(stakedInfo.nftId);

            if (tokenType == bestStakedType) {
                ++amountStakedOfBestType;
                if (earliestTimeStakedOfBestType > stakedInfo.stakedSince) {
                    earliestTimeStakedOfBestType = stakedInfo.stakedSince;
                }
            } else if (tokenType > bestStakedType) {
                bestStakedType = tokenType;
                amountStakedOfBestType = 1;
                earliestTimeStakedOfBestType = stakedInfo.stakedSince;
            }
        }
        return (
            bestStakedType,
            amountStakedOfBestType,
            earliestTimeStakedOfBestType
        );
    }

    function getStakedNFTInfos(
        address _userAddress
    ) external view returns (StakeInfo[] memory) {
        return userStakeInfo[_userAddress];
    }

    function getStakedInfoForNFTId(
        address _userAddress,
        uint16 _nftId
    ) external view returns (StakeInfo memory) {
        return userStakeInfo[_userAddress][nftIdToIndex[_nftId]];
    }

    //ADMIN===================================================================
    function setFoundersKeyAddress(
        address _foundersKeyAddress
    ) external onlyOwner {
        if (_foundersKeyAddress == address(0)) {
            revert AddressIsZero(_foundersKeyAddress);
        }
        FoundersKey = IFoundersKey(_foundersKeyAddress);
    }

    function setSoulboundFoundersKeyAddress(
        address _soulboundFoundersKeyAddress
    ) external onlyOwner {
        if (_soulboundFoundersKeyAddress == address(0)) {
            revert AddressIsZero(_soulboundFoundersKeyAddress);
        }
        SoulboundFoundersKey = ISoulboundFoundersKey(
            _soulboundFoundersKeyAddress
        );
    }

    function setZkSyncAddress(
        address _zkSyncAddress
    ) external onlyOwner {
        if (_zkSyncAddress == address(0)) {
            revert AddressIsZero(_zkSyncAddress);
        }
        zkSyncAddress = _zkSyncAddress;
    }

    function setZkSyncNaffleContractAddress(
        address _zkSyncNaffleContractAddress
    ) external onlyOwner {
        if (_zkSyncNaffleContractAddress == address(0)) {
            revert AddressIsZero(_zkSyncNaffleContractAddress);
        }
        zkSyncNaffleContractAddress = _zkSyncNaffleContractAddress;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    uint256[42] private __gap;
}
