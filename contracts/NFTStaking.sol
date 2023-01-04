// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IFoundersKey.sol";
import "../interfaces/ISoulBoundFoundersKey.sol";

contract FoundersKeyStaking is ERC721Holder, Ownable {
    address public FoundersKeyAddress;
    address public SoulBoundFoundersKeyAddress;

    struct StakeInfo {
        uint16 nftId;
        uint256 stakedTime;
        uint256 unstakedTime;
    }

    mapping(address => StakeInfo) public userStakeInfo;
    mapping(address => bool) public isUserStaked;

    event UserStaked(address userAddress, uint16 nftId, uint256 stakeTime);
    event UserUnstaked(address userAddress, uint16 nftId, uint256 unstakeTime);

    constructor(address _foundersKeyAddress, address _soulBoundFoundersKeyAddress) {
        FoundersKeyAddress = _foundersKeyAddress;
        SoulBoundFoundersKeyAddress = _soulBoundFoundersKeyAddress;
    }

    function stake(uint16 _nftId) external {
        require(!isUserStaked[msg.sender], "You already staked 1 NFT!");

        // SafeMint SoulBoundNFT
        ISoulBoundFoundersKey(SoulBoundFoundersKeyAddress).safeMint(msg.sender, _nftId);

        IERC721(FoundersKeyAddress).transferFrom(msg.sender, address(this), _nftId);
        isUserStaked[msg.sender] = true;
        userStakeInfo[msg.sender] = StakeInfo(_nftId, block.timestamp, 0);

        emit UserStaked(msg.sender, _nftId, block.timestamp);
    }

    function unstake() external {
        require(isUserStaked[msg.sender], "You didn't stake NFT!");

        uint16 nftId = userStakeInfo[msg.sender].nftId;
        IERC721(FoundersKeyAddress).transferFrom(address(this), msg.sender, nftId);
        isUserStaked[msg.sender] = false;
        userStakeInfo[msg.sender].unstakedTime = block.timestamp;
        
        ISoulBoundFoundersKey(SoulBoundFoundersKeyAddress).burn(nftId);

        emit UserUnstaked(msg.sender, nftId, block.timestamp);
    }

    // We want to get the type of key that is staked (use the type function on our founders key contract).
    function getUserStakedNFTType(address _userAddress) public view returns(uint8) {
        if (isUserStaked[_userAddress]) {
            return IFoundersKey(FoundersKeyAddress).tokenType(userStakeInfo[_userAddress].nftId);
        } else {
            return 0;
        }
    }

    // Function to see if an address staked before a certain date.
    function isUserStakedBefore(uint256 _time, address _userAddress) public view returns (bool) {
        if (isUserStaked[_userAddress]) {
            return userStakeInfo[_userAddress].stakedTime < _time;
        } else {
            return false;
        }
    }

    function checkUserStakeDuration(address _userAddress, uint256 _duration) public view returns (bool) {
        return block.timestamp - userStakeInfo[_userAddress].stakedTime >= _duration;
    }

    function setFoundersKeyAddress(address _foundersKeyAddress) external onlyOwner {
        require(_foundersKeyAddress != address(0), "can't use address 0");
        FoundersKeyAddress = _foundersKeyAddress;
    }

    function setSoulBoundFoundersKeyAddress(address _soulBoundFoundersKeyAddress) external onlyOwner {
        require(_soulBoundFoundersKeyAddress != address(0), "can't use address 0");
        SoulBoundFoundersKeyAddress = _soulBoundFoundersKeyAddress;
    }
}