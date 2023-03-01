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
    function _mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 ticketPriceInWei) internal returns(uint256[] memory ticketIds) {
        ticketIds = new uint256[](_amount);
        L2PaidTicketStorage.Layout storage l = PaidTicketBaseStorage.layout();
        NaffleTypes.L2Naffle memory naffle = IL2NaffleView(l.naffleContract).getNaffleById(_naffleId);

        for (uint256 i = naffle.numberOfPaidTickets; i < _amount; ++i) {
            NaffleTypes.PaidTicket
                memory paidTicket = NaffleTypes.PaidTicket({
                    owner: _to,
                    ticketIdOnNaffle: ticketIdOnNaffle,
                    ticketPriceInWei: _ticketPriceInWei,
                    naffleId: _naffleId,
                    winningTicket: false
                });
            _safeMint(_to, _totalSupply() + 1);
            uint256 totalSupply = _totalSupply();
            l.ticketIdNaffleTicketId[totalSupply] = ticketIdOnNaffle;
            l.paidTickets[_naffleId][ticketIdOnNaffle] = paidTicket;
            ticketIds[i] = totalSupply;
        }
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
}
