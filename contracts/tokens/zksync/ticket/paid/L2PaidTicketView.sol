// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketView.sol";

contract L2PaidTicketView is IL2PaidTicketView, L2PaidTicketBaseInternal {
    function getL2NaffleContractAddress() external view returns (address) {
        return _getL2NaffleContractAddress();
    }

    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }
}