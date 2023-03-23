// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL1NaffleBaseInternal {
    error NotAllowed();
    error InvalidEndTime(uint256 endTime);
    error InvalidTokenType();
    error InvalidPaidTicketSpots(uint256 spots);
    error MessageAlreadyProcessed();
    error FailedMessageInclusion();
    error InvalidAction();
    error printString(address message);
}
