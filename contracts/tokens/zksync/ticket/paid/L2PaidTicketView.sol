// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketBaseInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketView.sol";

contract L2PaidTicketView is IL2PaidTicketView, L2PaidTicketBaseInternal {
    /**
     * @inheritdoc IL2PaidTicketView
     */
    function getL2NaffleContractAddress() external view returns (address) {
        return _getL2NaffleContractAddress();
    }

    /**
     * @inheritdoc IL2PaidTicketView
     */
    function getAdminRole() external pure returns (bytes32) {
        return _getAdminRole();
    }
}
