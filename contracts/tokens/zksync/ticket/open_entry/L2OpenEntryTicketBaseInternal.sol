// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2OpenEntryTicketStorage.sol";

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBaseInternal.sol";


abstract contract L2OpenEntryTicketBaseInternal is IL2OpenEntryTicketBaseInternal, AccessControlInternal, ERC721BaseInternal, ERC721EnumerableInternal {
    function _attachToNaffle(uint256 _naffleId, uint256[] memory _ticketIds) internal {
        L2OpenEntryTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        for (uint256 i = 0; i < _ticketIds.length; i++) {
            NaffleTypes.OpenEntryTicket memory ticket = l.openEntryTickets[_ticketIds[i]];
            ticket.naffleId = _naffleId;
        }
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getL2NaffleContractAddress() internal view returns (address) {
        return L2OpenEntryTicketStorage.layout().l2NaffleContractAddress;
    }

    function _setL2NaffleContractAddress(address _l2NaffleContractAddress) internal {
        L2OpenEntryTicketStorage.layout().l2NaffleContractAddress = _l2NaffleContractAddress;
    }

    function _getTotalSupply() internal view returns (uint256) {
        return _totalSupply();
    }

    function _getTicketById(uint256 _ticketId) internal view returns (NaffleTypes.OpenEntryTicket memory) {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();
        return l.openEntryTickets[_ticketId];
    }
}
