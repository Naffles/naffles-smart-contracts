// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title interface for L2OpenEntryTicketBaseInternal
 */
interface IL2OpenEntryTicketBaseInternal {

    /**
     * @notice thrown when the msg.sender is not allowed to call the method.
     */
    error NotAllowed();

    /**
     * @notice thrown when the ticket is already used.
     * @param ticketId the id of the ticket.
     */
    error TicketAlreadyUsed(uint256 ticketId);

    /**
     * @notice thrown when the ticket is not owned by the sender.
     * @param ticketId the id of the ticket.
     */
    error NotOwnerOfTicket(uint256 ticketId);

    /**
     * @notice thrown when the naffle is not cancelled.
     * @param status the status of the naffle.
     */
    error NaffleNotCancelled(NaffleTypes.NaffleStatus status);

    /**
     * @notice thrown when the provided ticket id is not valid.
     * @param ticketId the id of the ticket.
     */
    error InvalidTicketId(uint256 ticketId);

    /**
     * @notice thrown when the sender is not the owner of the ticket.
     * @param sender the sender of the message.
     */
    error NotTicketOwner(address sender);
}
