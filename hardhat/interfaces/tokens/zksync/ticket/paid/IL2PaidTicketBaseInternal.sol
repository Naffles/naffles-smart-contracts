// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title interface for L2PaidTicketBaseInternal
 */
interface IL2PaidTicketBaseInternal {
    /**
     * @notice thrown when the msg.sender is not allowed to call the method.
     */
    error NotAllowed();

    /**
     * @notice thrown when the naffle is not cancelled
     * @param status the current status of the naffle.
     */
    error NaffleNotCancelled(NaffleTypes.NaffleStatus status);

    /**
     * @notice thrown when the refund transaction failed.
     */
    error RefundFailed();

    /**
     * @notice emitted when paid tickets are minted.
     * @param owner the owner of the tickets.
     * @param naffleId the id of the naffle.
     * @param ticketPriceInWei the price of the ticket in wei.
     * @param startingTicketId the starting ticket id on the naffle.
     * @param amount the amount of tickets minted.
     */
    event PaidTicketsMinted(
        address indexed owner,
        uint256 indexed naffleId,
        uint256 ticketPriceInWei,
        uint256 startingTicketId,
        uint256 amount
    );

    /**
     * @notice emitted when a paid ticket is refunded and burned.
     * @param owner the owner of the ticket.
     * @param naffleId the id of the naffle.
     * @param numberOfPaidTickets the number of paid tickets refunded.
     */
    event PaidTicketsRefundedAndBurned(
        address indexed owner,
        uint256 indexed naffleId,
        uint256 numberOfPaidTickets 
    );
}
