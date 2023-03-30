// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

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
     * @notice thrown when the L2 message is not included in the block.
     */
    error FailedMessageInclusion();

    /**
     * @notice thrown when the L2 message does not include a valid action.
     */
    error InvalidAction();
}
