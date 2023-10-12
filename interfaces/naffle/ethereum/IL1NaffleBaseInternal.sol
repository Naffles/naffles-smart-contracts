// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title interface for L1NaffleBaseInternal
 */
interface IL1NaffleBaseInternal {
    /**
     * @notice thrown when the msg.sender is not allowed to call this message.
     */
    error NotAllowed();

    /**
     * @notice thrown when the end time provided to the naffle is not valid.
     * @param endTime provided end time.
     */
    error InvalidEndTime(uint256 endTime);

    /**
     * @notice thrown when the token type is invalid.
     */
    error InvalidTokenType();

    /**
     * @notice thrown when there are an invalid number of ticket spots provided.
     * @param spots ticket spots.
     */
    error InvalidPaidTicketSpots(uint256 spots);

    /**
     * @notice thrown when the L2 message is already processed.
     */
    error MessageAlreadyProcessed();

    /**
     * @notice thrown when the L2 message is invalid
     */
    error FailedMessageInclusion();

    /**
     * @notice thrown when insufficient gas is forwarded for the create naffle call.
     */ 
    error InsufficientL2GasForwardedForCreateNaffle();

    /**
     * @notice emitted when a naffle is created.
     * @param naffleId id of the naffle.
     * @param owner address of the owner.
     * @param paidTicketSpots number of paid ticket spots.
     * @param ticketPriceInWei price of the ticket in wei.
     * @param endTime end time of the naffle.
     * @param naffleType type of the naffle.
     */
    event L1NaffleCreated(
        NaffleTypes.NaffleTokenInformation naffleTokenInformation,
        uint256 naffleId,
        address indexed owner,
        uint256 paidTicketSpots,
        uint256 ticketPriceInWei,
        uint256 endTime,
        NaffleTypes.NaffleType naffleType
    );

    /**
     * @notice emitted when winner is set on the naffle.
     * @param naffleId id of the naffle.
     * @param winner address of the winner.
     */
    event L1NaffleWinnerSet(
        uint256 indexed naffleId,
        address indexed winner
    );

    /**
     * @notice emitted when a naffle is cancelled.
     * @param naffleId id of the naffle.
     */
    event L1NaffleCancelled(
        uint256 naffleId
    );
}
