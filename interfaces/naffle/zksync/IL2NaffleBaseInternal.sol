// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title Interface for L2 Naffle Base Internal
 */
interface IL2NaffleBaseInternal {
    /**
     * @notice thrown when the msg.sender is not allowed to call the function.
     */
    error NotAllowed();

    /**
     * @notice thrown when the naffle id is invalid.
     * @param naffleId the naffle id.
     */
    error InvalidNaffleId(uint256 naffleId);

    /**
     * @notice thrown when the naffle status is invalid.
     * @param status the naffle status.
     */
    error InvalidNaffleStatus(NaffleTypes.NaffleStatus status);

    /**
     * @notice thrown when not enough funds are sent to pay for the tickets.
     * @param amount funds sent to buy tickets.
     */
    error NotEnoughFunds(uint256 amount);

    /**
     * @notice thrown when not enough paid ticket spots are available on the naffle.
     * @param amount amount of tickets to buy.
     */
    error NotEnoughPaidTicketSpots(uint256 amount);

    /**
     * @notice thrown when not enough open entry ticket spots are available on the naffle.
     * @param amount amount of tickets to buy.
     */
    error NotEnoughOpenEntryTicketSpots(uint256 amount);

    /**
     * @notice thrown when the open entry ratio is zero.
     */
    error OpenTicketRatioCannotBeZero();

    /**
     * @notice thrown when the naffle has not ended yet.
     * @param endTime end time of the naffle.
     */
    error NaffleNotEndedYet(uint256 endTime);

    /**
     * @notice thrown when the naffle is sold out.
     */
    error NaffleSoldOut();

    /**
     * @notice thrown when the naffle type is invalid.
     * @param naffleType naffle type.
     */
    error InvalidNaffleType(NaffleTypes.NaffleType naffleType);

    /**
     * @notice thrown when there are no tickets to draw a winner from.
     */
    error NoTicketsBought();

    /**
     * @notice thrown when the withdraw of funds fails.
     */
    error UnableToSendFunds();

    /**
     * @notice thrown when there are not enough funds to withdraw.
     */
    error InsufficientFunds();
}
