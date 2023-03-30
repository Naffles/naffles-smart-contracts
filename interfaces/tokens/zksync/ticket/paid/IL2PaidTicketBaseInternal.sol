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
}
