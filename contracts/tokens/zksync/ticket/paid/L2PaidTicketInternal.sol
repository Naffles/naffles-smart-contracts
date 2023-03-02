// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketStorage.sol";

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBaseInternal.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";
import "../../../../../interfaces/naffle/zksync/IL2NaffleView.sol";



abstract contract L2PaidTicketBaseInternal is IL2PaidTicketBaseInternal, AccessControlInternal, ERC721BaseInternal, ERC721EnumerableInternal {
    event Log(string message, uint data);

    function _mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 _ticketPriceInWei) internal returns(uint256[] memory) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        NaffleTypes.L2Naffle memory naffle = IL2NaffleView(l.l2NaffleContractAddress).getNaffleById(_naffleId);
        uint256[] memory ticketIds = new uint256[](_amount);
        uint256 count = 0;
        for (uint256 i = naffle.numberOfPaidTickets - _amount; i < naffle.numberOfPaidTickets; ++i) {
            uint256 ticketId = i + 1;
            NaffleTypes.PaidTicket
                memory paidTicket = NaffleTypes.PaidTicket({
                    owner: _to,
                    ticketIdOnNaffle: ticketId,
                    ticketPriceInWei: _ticketPriceInWei,
                    naffleId: _naffleId,
                    winningTicket: false
                });
            uint256 totalTicketId = _totalSupply() + 1;
            _mint(_to, totalTicketId);
            l.ticketIdNaffleTicketId[totalTicketId] = ticketId;
            l.paidTickets[_naffleId][ticketId] = totalTicketId;
            l.paidTickets[totalTicketId] = paidTicket;
            ticketIds[count] = ticketId;
            ++count;
        }
        return ticketIds;
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getL2NaffleContractAddress() internal view returns (address) {
        return L2PaidTicketStorage.layout().l2NaffleContractAddress;
    }

    function _setL2NaffleContractAddress(address _l2NaffleContractAddress) internal {
        L2PaidTicketStorage.layout().l2NaffleContractAddress = _l2NaffleContractAddress;
    }

    function _getTicketByIdOnNaffle(uint256 _ticketIdOnNaffle, uint256 _naffleId) internal view returns (NaffleTypes.PaidTicket memory) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        return l.paidTickets[_naffleId][_ticketIdOnNaffle];
    }

    function _getTicketById(uint256 _ticketId) internal view returns (NaffleTypes.PaidTicket memory) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        uint256 ticketIdOnNaffle = l.ticketIdNaffleTicketId[_ticketId];
        return l.paidTickets[_naffleId][ticketIdOnNaffle];
    }
}
