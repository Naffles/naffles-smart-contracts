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
    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }

    /**
     * @inheritdoc IL2OpenEntryTicketView
     */
    function getTotalSupply() external view returns (uint256) {
        return _getTotalSupply();
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
    function getOwnerOfNaffleTicketId(uint256 _naffleId, uint256 _ticketIdOnNaffle) external view override returns (address) {
        return _getOwnerOfNaffleTicketId(_naffleId, _ticketIdOnNaffle);
    }
}