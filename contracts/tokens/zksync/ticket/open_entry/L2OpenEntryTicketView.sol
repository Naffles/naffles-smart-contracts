// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketView.sol";
import "../paid/L2PaidTicketBaseInternal.sol";
import "./L2OpenEntryTicketBaseInternal.sol";


contract L2OpenEntryTicketView is IL2OpenEntryTicketView, L2OpenEntryTicketBaseInternal {
    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }
}