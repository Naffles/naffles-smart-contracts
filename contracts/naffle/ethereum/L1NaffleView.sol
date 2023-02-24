// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./L1NaffleBaseInternal.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleView.sol";

contract L1NaffleView is IL1NaffleView, L1NaffleBaseInternal {
    function getMinimumNaffleDuration() external view returns (uint256) {
        return _getMinimumNaffleDuration();
    }

    function getMinimumPaidTicketSpots() external view returns (uint256) {
        return _getMinimumPaidTicketSpots();
    }

    function getZkSyncNaffleContractAddress() external view returns (address) {
        return _getZkSyncNaffleContractAddress();
    }

    function getZkSyncAddress() external view returns (address) {
        return _getZkSyncAddress();
    }

    function getFoundersKeyAddress() external view returns (address) {
        return _getFoundersKeyAddress();
    }

    function getFoundersKeyPlaceholderAddress() external view returns (address) {
        return _getFoundersKeyPlaceholderAddress();
    }

    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }
}