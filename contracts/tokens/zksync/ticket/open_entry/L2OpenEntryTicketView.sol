// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketView.sol";
import "./L2OpenEntryTicketBaseInternal.sol";


contract L2OpenEntryTicketView is IL2OpenEntryTicketView, L2OpenEntryTicketBaseInternal {
    /**
     * @inheritdoc IL2OpenEntryTicketView
     */
    function getL2NaffleContractAddress() external view returns (address) {
        return _getL2NaffleContractAddress();
    }

    /**
     * @inheritdoc IL2OpenEntryTicketView
     */
    function getAdminRole() external pure returns (bytes32) {
        return _getAdminRole();
    }

    /**
     * @inheritdoc IL2OpenEntryTicketView
     */
    function getOpenEntryTicketById(uint256 _ticketId) external view returns (NaffleTypes.OpenEntryTicket memory) {
        return _getOpenEntryTicketById(_ticketId);
    }

    /**
     * @inheritdoc IL2OpenEntryTicketView
     */
    function getSignatureSigner() external view returns (address) {
        return _getSignatureSigner();
    }

    /**
     * @inheritdoc IL2OpenEntryTicketView
     */
    function getDomainName() external view returns (string memory) {
        return _getDomainName();
    }
}
