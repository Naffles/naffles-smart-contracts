// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

interface IL2OpenEntryTicketBaseInternal {
    error NotAllowed();
    error TicketAlreadyUsed(uint256 ticketId);
    error NotOwnerOfTicket(uint256 ticketId);
    error NaffleNotCancelled(NaffleTypes.NaffleStatus status);
    error InvalidTicketId(uint256 ticketId);
    error NotTicketOwner(address sender);
}