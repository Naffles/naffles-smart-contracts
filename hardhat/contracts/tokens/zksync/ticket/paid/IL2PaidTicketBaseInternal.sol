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
     * @notice thrown when an invalid ticket id is passed.
     * @param ticketId the ticket id passed.
     */
    error InvalidTicketId(uint256 ticketId);

    /**
     * @notice thrown when the refund transaction failed.
     */
    error RefundFailed();

    /**
     * @notice thrown when the sender is not the owner of the ticket.
     * @param sender the called of the method.
     */
    error NotTicketOwner(address sender);

    /**
     * @notice emitted when paid tickets are minted.
     * @param owner the owner of the tickets.
     * @param ticketIds the ids of the tickets.
     * @param naffleId the id of the naffle.
     * @param ticketPriceInWei the price of the ticket in wei.
     * @param startingTicketId the starting ticket id on the naffle.
     */
    event PaidTicketsMinted(
        address indexed owner,
        uint256[] ticketIds,
        uint256 indexed naffleId,
        uint256 ticketPriceInWei,
        uint256 startingTicketId
    );

    /**
     * @notice emitted when a paid ticket is refunded and burned.
     * @param owner the owner of the ticket.
     * @param naffleId the id of the naffle.
     * @param ticketId the id of the ticket.
     * @param ticketIdOnNaffle the id of the ticket on the naffle.
     */
    event PaidTicketRefundedAndBurned(
        address indexed owner,
        uint256 indexed naffleId,
        uint256 ticketId,
        uint256 ticketIdOnNaffle
    );
}
