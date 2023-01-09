// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "../../interfaces/IFoundersKey.sol";
import "../../interfaces/ISoulboundFoundersKey.sol";

error NFTAlreadyStaked(uint16 nftId);
error NFTLocked(uint16 nftId, uint256 unlockTime);

contract FoundersKeyStaking is ERC721Holder, Ownable, Pausable {
    IFoundersKey public FoundersKeyAddress;
    ISoulboundFoundersKey public SoulboundFoundersKeyAddress;

    enum StakingPeriod { ONE_MONTH, THREE_MONTHS, SIX_MONTHS, TWELVE_MONTHS }

    uint256 public constant ONE_MONTH = 30 days;
    uint256 public constant THREE_MONTHS = 90 days;
    uint256 public constant SIX_MONTHS = 180 days;
    uint256 public constant TWELVE_MONTHS = 365 days;

    struct StakeInfo {
        uint16 nftId;
        uint256 stakedSince;
        StakingPeriod stakingPeriod;
    }

    mapping(uint16 => uint) private nftIdToIndex;
    mapping(address => uint16[]) public stakedNFTIds;
    mapping(address => StakeInfo[]) public userStakeInfo;

    event UserStaked(address userAddress, uint16 nftId, uint256 stakeTime);
    event UserUnstaked(address userAddress, uint16 nftId, uint256 unstakeTime);

    constructor(
        address _foundersKeyAddress, 
        address _soulboundFoundersKeyAddress
    ) {
        FoundersKeyAddress = IFoundersKey(_foundersKeyAddress);
        SoulboundFoundersKeyAddress = ISoulboundFoundersKey(_soulboundFoundersKeyAddress);
    }

    function stake(uint16 _nftId, StakingPeriod _stakingPeriod) external whenNotPaused {
        SoulboundFoundersKeyAddress.safeMint(msg.sender, _nftId);
        FoundersKeyAddress.transferFrom(msg.sender, address(this), _nftId);

        StakeInfo memory stakeInfo = StakeInfo(_nftId, block.timestamp, _stakingPeriod);
        userStakeInfo[msg.sender].push(stakeInfo);
        stakedNFTIds[msg.sender].push(_nftId);
        nftIdToIndex[_nftId] = stakedNFTIds[msg.sender].length - 1;
     
        emit UserStaked(msg.sender, _nftId, block.timestamp);
    }

    function unstake(uint16 _nftId) external {
        StakeInfo storage stakeInfo = userStakeInfo[msg.sender][nftIdToIndex[_nftId]];
        if (stakeInfo.stakedSince + _getStakingPeriod(stakeInfo.stakingPeriod) > block.timestamp) {
            revert NFTLocked(_nftId, stakeInfo.stakedSince + _getStakingPeriod(stakeInfo.stakingPeriod));
        }
        FoundersKeyAddress.transferFrom(address(this), msg.sender, _nftId);
        SoulboundFoundersKeyAddress.burn(_nftId);
        delete userStakeInfo[msg.sender][nftIdToIndex[_nftId]];
        delete stakedNFTIds[msg.sender][nftIdToIndex[_nftId]];
        delete nftIdToIndex[_nftId];

        emit UserUnstaked(msg.sender, _nftId, block.timestamp);
    }

    function _getStakingPeriod(StakingPeriod _stakingPeriod) internal pure returns (uint256) {
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

    function getBestStakedNFTInfo(address _userAddress) external view returns(uint8, uint16, uint256) {
        uint8 bestStakedType = 0;
        uint16 amountStakedOfBestType = 0;
        uint256 earliestTimeStakedOfBestType = 0;

        uint16[] storage stakedNFTIdsForAddress = stakedNFTIds[_userAddress];
        StakeInfo[] storage stakedInfos = userStakeInfo[_userAddress];

        for (uint i = 0; i < stakedNFTIdsForAddress.length; i++) {
            uint16 nftId = stakedNFTIdsForAddress[i];
            StakeInfo storage stakedInfo = stakedInfos[nftIdToIndex[nftId]];
            uint8 tokenType = FoundersKeyAddress.tokenType(nftId);

            if (tokenType == bestStakedType) {
                amountStakedOfBestType++;
                if (earliestTimeStakedOfBestType > stakedInfo.stakedSince) {
                  earliestTimeStakedOfBestType = stakedInfo.stakedSince;
                }
            } else if (tokenType > bestStakedType) {
                amountStakedOfBestType = 1;
                earliestTimeStakedOfBestType = stakedInfo.stakedSince;
            }
        }
        return (bestStakedType, amountStakedOfBestType, earliestTimeStakedOfBestType);
    }

    function getStakedNFTInfos(address _userAddress) external view returns(StakeInfo[] memory) {
        return userStakeInfo[_userAddress];
    }

    function getStakedInfoForNFTId(address _userAddress, uint16 _nftId) external view returns(StakeInfo memory) {
        return userStakeInfo[_userAddress][nftIdToIndex[_nftId]];
    }

    function setFoundersKeyAddress(address _foundersKeyAddress) external onlyOwner {
        require(_foundersKeyAddress != address(0), "can't use address 0");
        FoundersKeyAddress = IFoundersKey(_foundersKeyAddress);
    }

    function setSoulboundFoundersKeyAddress(address _soulboundFoundersKeyAddress) external onlyOwner {
        require(_soulboundFoundersKeyAddress != address(0), "can't use address 0");
        SoulboundFoundersKeyAddress = ISoulboundFoundersKey(_soulboundFoundersKeyAddress);
    }
}
