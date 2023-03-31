// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketStorage.sol";

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBaseInternal.sol";
import "@solidstate/contracts/interfaces/IERC721.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";
import "../../../../../interfaces/naffle/zksync/IL2NaffleView.sol";
import "../../../../libraries/NaffleTypes.sol";


abstract contract L2PaidTicketBaseInternal is IL2PaidTicketBaseInternal, AccessControlInternal, ERC721BaseInternal, ERC721EnumerableInternal {
    function _mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 _ticketPriceInWei, uint256 startingTicketId) internal returns(uint256[] memory) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        uint256[] memory ticketIds = new uint256[](_amount);
        uint256 count = 0;
        for (uint256 i = startingTicketId; i < startingTicketId + _amount; i++) {
            NaffleTypes.PaidTicket
                memory paidTicket = NaffleTypes.PaidTicket({
                    ticketIdOnNaffle: i,
                    ticketPriceInWei: _ticketPriceInWei,
                    naffleId: _naffleId,
                    winningTicket: false
                });
            uint256 totalTicketId = _totalSupply() + 1;
            _mint(_to, totalTicketId);
            l.naffleIdNaffleTicketIdTicketId[_naffleId][i] = totalTicketId;
            l.paidTickets[totalTicketId] = paidTicket;
            ticketIds[count] = i;
            ++count;
        }
        return ticketIds;
    }

    function _refundAndBurnTicket(uint256 _naffleId, uint256 _naffleTicketId) internal {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        NaffleTypes.L2Naffle memory naffle = IL2NaffleView(_getL2NaffleContractAddress()).getNaffleById(_naffleId);
        if (naffle.status != NaffleTypes.NaffleStatus.CANCELLED) {
            revert NaffleNotCancelled(naffle.status);
        }
        uint256 totalTicketId = l.naffleIdNaffleTicketIdTicketId[_naffleId][_naffleTicketId];
        if (totalTicketId == 0) {
            revert InvalidTicketId(_naffleTicketId);
        }
        delete l.naffleIdNaffleTicketIdTicketId[_naffleId][_naffleTicketId];
        NaffleTypes.PaidTicket storage paidTicket = l.paidTickets[totalTicketId];
        address owner = _ownerOf(totalTicketId);
        if (owner != msg.sender) {
            revert NotTicketOwner(msg.sender);
        }
        (bool success, ) = owner.call{value: paidTicket.ticketPriceInWei}("");
        if (!success) {
            revert RefundFailed();
        }
        // We reset the naffle id so we know this is refunded because we can't delete custom structs.
        paidTicket.naffleId = 0;
        paidTicket.ticketIdOnNaffle = 0;
        _burn(totalTicketId);
    }

    function _getOwnerOfNaffleTicketId(uint256 _naffleId, uint256 _ticketIdOnNaffle) internal view returns (address owner) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        owner = _ownerOf(l.naffleIdNaffleTicketIdTicketId[_naffleId][_ticketIdOnNaffle]);
    }

    function _getAdminRole() internal view returns (bytes32 adminRole) {
        adminRole = AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getL2NaffleContractAddress() internal view returns (address l2NaffleContractAddress) {
        l2NaffleContractAddress = L2PaidTicketStorage.layout().l2NaffleContractAddress;
    }

    function _setL2NaffleContractAddress(address _l2NaffleContractAddress) internal {
        L2PaidTicketStorage.layout().l2NaffleContractAddress = _l2NaffleContractAddress;
    }

    function _getTicketByIdOnNaffle(uint256 _ticketIdOnNaffle, uint256 _naffleId) internal view returns (NaffleTypes.PaidTicket memory ticket) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        ticket = l.paidTickets[l.naffleIdNaffleTicketIdTicketId[_naffleId][_ticketIdOnNaffle]];
    }

    function _getTicketById(uint256 _ticketId) internal view returns (NaffleTypes.PaidTicket memory ticket) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        ticket = l.paidTickets[_ticketId];
    }
}
