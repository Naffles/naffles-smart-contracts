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

    function getZkSyncAddress() external view override returns (address) {
        return _getZkSyncAddress();
    }
}