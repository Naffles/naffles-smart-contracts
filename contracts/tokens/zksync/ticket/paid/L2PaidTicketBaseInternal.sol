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
    function _mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 _ticketPriceInWei, uint256 startingTicketId) internal returns(uint256[] memory) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        uint256[] memory ticketIds = new uint256[](_amount);
        uint256 count = 0;
        for (uint256 i = startingTicketId; i < startingTicketId + _amount; i++) {
            NaffleTypes.PaidTicket
                memory paidTicket = NaffleTypes.PaidTicket({
                    owner: _to,
                    ticketIdOnNaffle: i,
                    ticketPriceInWei: _ticketPriceInWei,
                    naffleId: _naffleId,
                    winningTicket: false
                });
            uint256 totalTicketId = _totalSupply() + 1;
            _mint(_to, totalTicketId);
            l.naffleIdNaffleTicketIdTicketId[_naffleId][i] = totalTicketId;
            l.ticketIdNaffleTicketId[totalTicketId] = i;
            l.paidTickets[totalTicketId] = paidTicket;
            ticketIds[count] = i;
            ++count;
        }
        return ticketIds;
    }

    function _refundTicket(uint256 _ticketId, uint256 _naffleId) internal {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        uint256 ticketIdOnNaffle = l.ticketIdNaffleTicketId[_ticketId];
        uint256 ticketId = l.naffleIdNaffleTicketIdTicketId[_naffleId][ticketIdOnNaffle];
        _burn(ticketId);

        delete l.naffleIdNaffleTicketIdTicketId[_naffleId][ticketIdOnNaffle];
        delete l.ticketIdNaffleTicketId[totalTicketId];
        delete l.paidTickets[ticketId];
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
        return l.paidTickets[l.naffleIdNaffleTicketIdTicketId[_naffleId][_ticketIdOnNaffle]];
    }

    function _getTicketById(uint256 _ticketId) internal view returns (NaffleTypes.PaidTicket memory) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        return l.paidTickets[_ticketId];
    }
}
