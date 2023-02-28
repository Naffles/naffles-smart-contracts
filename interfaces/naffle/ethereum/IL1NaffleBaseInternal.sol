// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL1NaffleBaseInternal {
    error NotAllowed();
    error InvalidEndTime(uint256 endTime);
    error InvalidTokenType();
    error NotEnoughPaidTicketSpots(uint256 tickets);
    error InvalidPaidTicketSpots(uint256 spots);
    error InvalidPaidTicketPrice(uint256 price);
}