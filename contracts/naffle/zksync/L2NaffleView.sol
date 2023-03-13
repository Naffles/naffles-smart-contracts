// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseInternal.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleView.sol";
import "../../libraries/NaffleTypes.sol";

contract L2NaffleView is IL2NaffleView, L2NaffleBaseInternal {
    function getPlatformFee() external view returns (uint256) {
        return _getPlatformFee();
    }

    function getFreeTicketRatio() external view returns (uint256) {
        return _getFreeTicketRatio();
    }

    function getL1NaffleContractAddress() external view returns (address) {
        return _getL1NaffleContractAddress();
    }

    function getNaffleById(uint256 _id) external view returns (NaffleTypes.L2Naffle memory) {
        return _getNaffleById(_id);
    }

    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }
}