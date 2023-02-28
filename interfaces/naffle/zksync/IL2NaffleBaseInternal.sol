// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

interface IL2NaffleBaseInternal {
    error NotAllowed();
    error InvalidNaffleId(uint256 naffleId);
    error InvalidNaffleStatus(NaffleTypes.NaffleStatus status);
    error NotEnoughFunds(uint256 amount);
    error NotEnoughPaidTicketSpots(uint256 amount);
}
