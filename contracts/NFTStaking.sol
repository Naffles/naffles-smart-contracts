// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "OpenZeppelin/openzeppelin-contracts@4.8.0/contracts/interfaces/IERC721.sol";
import "OpenZeppelin/openzeppelin-contracts@4.8.0/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./interfaces/IFoundersKey.sol";

contract FoundersKeyStaking is ERC721Holder {
    address public FoundersKeyAddress;

    struct StakeInfo {
        uint256 nftId;
        uint256 stakedTime;
        uint256 unstakedTime;
    }

    mapping(address => StakeInfo) public userStakeInfo;
    mapping(address => bool) public isUserStaked;

    event UserStaked(address userAddress, uint256 nftId, uint256 stakeTime);
    event UserUnstaked(address userAddress, uint256 nftId, uint256 unstakeTime);

    constructor(address _foundersKeyAddress) {
        FoundersKeyAddress = _foundersKeyAddress;
    }

    function stake(uint256 _nftId) external {
        require(!isUserStaked[msg.sender], "You already staked 1 NFT!");

        IERC721(FoundersKeyAddress).transferFrom(msg.sender, address(this), _nftId);
        isUserStaked[msg.sender] = true;
        userStakedNFTId[msg.sender] = StakeInfo(_nftId, block.timestamp, 0);

        emit UserStaked(msg.sender, _nftId, block.timestamp);
    }

    function unstake() external {
        require(isUserStaked[msg.sender], "You didn't stake NFT!");

        IERC721(FoundersKeyAddress).transfer(msg.sender, userStakedNFTId[msg.sender]);
        isUserStaked[msg.sender] = false;
        userStakeInfo[msg.sender].unstakedTime = block.timestamp;
        
        emit UserUnstaked(msg.sender, _nftId, block.timestamp);
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

    // TODO: Function to see if an address staked for a specific duration up until now.
}