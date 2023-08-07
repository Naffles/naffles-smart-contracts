// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL2OpenEntryTicketBaseInternal {
    error NotAllowed();
    error TicketAlreadyUsed(uint256 ticketId);
    error NotOwnerOfTicket(uint256 ticketId);
}
