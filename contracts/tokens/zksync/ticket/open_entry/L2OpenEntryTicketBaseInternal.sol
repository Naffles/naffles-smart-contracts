// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2OpenEntryTicketStorage.sol";

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";
import "../../../../../interfaces/naffle/zksync/IL2NaffleView.sol";
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBaseInternal.sol";


abstract contract L2OpenEntryTicketBaseInternal is IL2OpenEntryTicketBaseInternal, AccessControlInternal, ERC721BaseInternal, ERC721EnumerableInternal {
    function _attachToNaffle(uint256 _naffleId, uint256[] memory _ticketIds, uint256 startingTicketId, address owner) internal {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();
        for (uint256 i = 0; i < _ticketIds.length; i++) {
            uint256 ticketId = _ticketIds[i];
            NaffleTypes.OpenEntryTicket storage ticket = l.openEntryTickets[ticketId];
            if (ticket.naffleId != 0) {
                revert TicketAlreadyUsed(ticketId);
            }
            if (_ownerOf(ticketId) != owner) {
                revert NotOwnerOfTicket(ticketId);
            }
            ticket.naffleId = _naffleId;
            ticket.ticketIdOnNaffle = startingTicketId;
            l.naffleIdTicketIdOnNaffleTicketId[_naffleId][startingTicketId] = ticketId;
            ++startingTicketId;
        }
    }

    function _detachFromNaffle(uint256 _naffleId, uint256 _naffleTicketId) internal {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();
        NaffleTypes.L2Naffle memory naffle = IL2NaffleView(_getL2NaffleContractAddress()).getNaffleById(_naffleId);
        if (naffle.status != NaffleTypes.NaffleStatus.CANCELLED) {
            revert NaffleNotCancelled(naffle.status);
        }
        uint256 totalTicketId = l.naffleIdTicketIdOnNaffleTicketId[_naffleId][_naffleTicketId];
        NaffleTypes.OpenEntryTicket memory ticket = l.openEntryTickets[totalTicketId];
        if (totalTicketId == 0) {
            revert InvalidTicketId(_naffleTicketId);
        }
        address owner = _ownerOf(totalTicketId);
        if (owner != msg.sender) {
            revert NotTicketOwner(msg.sender);
        }
        ticket.naffleId = 0;
        ticket.ticketIdOnNaffle = 0;
        l.openEntryTickets[totalTicketId] = ticket;
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

    function _getOpenEntryTicketById(uint256 _ticketId) internal view returns (NaffleTypes.OpenEntryTicket memory) {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();
        return l.openEntryTickets[_ticketId];
    }
}
