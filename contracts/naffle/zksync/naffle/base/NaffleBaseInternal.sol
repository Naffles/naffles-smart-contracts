// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { NaffleBaseStorage } from "./NaffleBaseStorage.sol";
import { AccessControlStorage } from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import { IPaidTicketBase } from "../../../../../interfaces/tokens/zksync/tickets/paid/base/IPaidTicketBase.sol";

error NotEnoughFunds(uint256 funds);
error NotEnoughPaidTicketSpots(uint256 tickets);
error NaffleNotActive();

contract NaffleBaseInternal {
    function _buyTickets(uint256 _amount, uint256 _naffleId) internal returns (uint256[] memory ticketIds) {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleBaseStorage.Naffle storage naffle = layout.naffles[_naffleId];

        if (msg.value < _amount * naffle.ticketPriceInWei) {
            revert NotEnoughFunds(msg.value);
        }
        uint256 ticketSpots = naffle.paidTicketSpots;
        if (naffle.numberOfPaidTickets > naffle.paidTicketSpots) {
            revert NotEnoughPaidTicketSpots(naffle.paidTicketSpots);
        }
        if (
            naffle.status != NaffleBaseStorage.NaffleStatus.ACTIVE || 
            naffle.status != NaffleBaseStorage.NaffleStatus.POSTPONED
        ) {
            revert NaffleNotActive();
        }
        ticketIds = layout.paidTicketContract.mintTickets(msg.sender, _amount, _naffleId, naffle.ticketPriceInWei);
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function setPaidTicketContract(address _paidTicketContract) internal{
        NaffleBaseStorage.layout().paidTicketContract = IPaidTicketBase(_paidTicketContract);
    }

    function _getTicketPriceForNaffle(uint256 _naffleId) internal view returns (uint256) {
        return NaffleBaseStorage.layout().naffles[_naffleId].ticketPriceInWei;
    }
}
