// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/**
 * @title L1NaffleBaseInternal interface
 * @dev interface for internal functions of L1NaffleBase
 */
interface IL1NaffleBaseInternal {

    /**
     * @notice thrown when the msg.sender is not allowed to call this message.
     */
    error NotAllowed();

    /**
     * @notice thrown when the end time provided to the naffle is not valid.
     * @return provided end time.
     */
    error InvalidEndTime(uint256 endTime);

    /**
     * @notice thrown when the token type is invalid.
     */
    error InvalidTokenType();

    /**
     * @notice thrown when there are an invalid number of ticket spots provided.
     * @return provided number of ticket spots.
     */
    error InvalidPaidTicketSpots(uint256 spots);

    /**
     * @notice thrown when the L2 message is already processed.
     */
    error MessageAlreadyProcessed();

    /**
     * @notice thrown when the L2 message is not included in the block.
     */
    error FailedMessageInclusion();

    /**
     * @notice thrown when the L2 message does not include a valid action.
     */
    error InvalidAction();
}
