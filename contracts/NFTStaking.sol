// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "../interfaces/IFoundersKey.sol";
import "../interfaces/ISoulBoundFoundersKey.sol";

contract FoundersKeyStaking is ERC721Holder, Ownable, Pausable {
    address public FoundersKeyAddress;
    address public SoulBoundFoundersKeyAddress;

    enum StakingPeriond { ONE_MONTH, THREE_MONTHS, SIX_MONTHS, TWELVE_MONTHS }

    uint256 public constant ONE_MONTH = 30 days;
    uint256 public constant THREE_MONTHS = 90 days;
    uint256 public constant SIX_MONTHS = 180 days;
    uint256 public constant TWELVE_MONTHS = 365 days;

    struct StakeInfo {
        uint16 nftId;
        uint256 stakedSince;
        uint256 unstakedSince;
        StakingPeriond stakingPeriod;
    }

    mapping(address => mapping(uint16 => uint)) public nftIdToIndex;
    mapping(address => uint16[]) public stakedNFTIds;
    mapping(address => StakeInfo[]) public userStakeInfo;

    event UserStaked(address userAddress, uint16 nftId, uint256 stakeTime);
    event UserUnstaked(address userAddress, uint16 nftId, uint256 unstakeTime);

    constructor(
        address _foundersKeyAddress, 
        address _soulBoundFoundersKeyAddress
    ) {
        FoundersKeyAddress = _foundersKeyAddress;
        SoulBoundFoundersKeyAddress = _soulBoundFoundersKeyAddress;
    }

    function stake(uint16 _nftId, StakingPeriod _stakingPeriod) external whenNotPaused {
        ISoulBoundFoundersKey(SoulBoundFoundersKeyAddress).safeMint(msg.sender, _nftId);
        IERC721(FoundersKeyAddress).transferFrom(msg.sender, address(this), _nftId);
        StakeInfo memory stakeInfo = StakeInfo(_nftId, bytes32(block.timestamp), 0, _stakingPeriod);

        userStakeInfo[msg.sender].push(stakeInfo);
        stakedNFTIds[msg.sender].push(_nftId);
        nftIdToIndex[msg.sender][_nftId] = stakedNFTIds[msg.sender].length - 1;

        emit UserStaked(msg.sender, _nftId, block.timestamp);
    }

    function unstake(uint16 _nftId) external {
        require(_nftId != 0, "NFT ID can't be 0!");
        StakeInfo storage stakeInfo = userStakeInfo[msg.sender][_nftId];
        require(stakeInfos[index].nftId != 0, "You didn't stake NFT!");
        require(stakeInfo.stakedSince + getStakingPeriod(stakeInfo.stakingPeriod) < block.timestamp, "NFT is still locked!");

        IERC721(FoundersKeyAddress).transferFrom(address(this), msg.sender, _nftId);
        stakeInfos[index].unstakedSince = bytes32(block.timestamp);
        ISoulBoundFoundersKey(SoulBoundFoundersKeyAddress).burn(_nftId);

        uint16[] storage stakedNFTIds = stakedNFTIds[msg.sender];
        delete stakedNFTIds[index];

        emit UserUnstaked(msg.sender, _nftId, block.timestamp);
    }

    function getStakingPeriodInDays(StakingPeriod _stakingPeriod) public pure returns (uint256) {
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

    // returns the staked info for the best pass types currently staked.
    function getBestStakedNFTInfos(address _userAddress) external view returns(StakedInfo[] memory) {
        uint16 bestStakedType = 0;
        StakedInfos[] memory bestStakedInfos;
        uint16[] storage stakedNFTIds = stakedNFTIds[_userAddress];
        for (uint i = 0; i < stakedNFTIds.length; i++) {
            uint16 nftId = stakedNFTIds[i];
            StakedInfo memory stakedInfo = userStakeInfo[_userAddress][nftId];
            uint16 tokenType = IFoundersKey(FoundersKeyAddress).tokenType(nftId);
            if (tokenType >= bestStakedType) {
                bestStakedType = tokenType;
                bestStakedInfos.push = stakedInfo;
            } 
        }
        return bestStakedInfos;
    }

    function setFoundersKeyAddress(address _foundersKeyAddress) external onlyOwner {
        require(_foundersKeyAddress != address(0), "can't use address 0");
        FoundersKeyAddress = _foundersKeyAddress;
    }

    function setSoulBoundFoundersKeyAddress(address _soulBoundFoundersKeyAddress) external onlyOwner {
        require(_soulBoundFoundersKeyAddress != address(0), "can't use address 0");
        SoulBoundFoundersKeyAddress = _soulBoundFoundersKeyAddress;
    }

    function setBonusStakeTimeLimit(uint256 _bonusStakeTimeLimit) external onlyOwner {
        bonusStakeTimeLimit = _bonusStakeTimeLimit;
    }
}
