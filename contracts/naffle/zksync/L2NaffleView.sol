// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseInternal.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleView.sol";

contract L2NaffleView is IL2NaffleView, L2NaffleBaseInternal {
    function getPlatformFee() external view override returns (uint256) {
        return _getPlatformFee();
    }

    function getFreeTicketRatio() external view override returns (uint256) {
        return _getFreeTicketRatio();
    }

    function getL1NaffleContractAddress() external view override returns (address) {
        return _getL1NaffleContractAddress();
    }

    function getAdminRole() external view override returns (bytes32) {
        return _getAdminRole();
    }
}