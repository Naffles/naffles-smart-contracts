// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

interface IL2PaidTicketBaseInternal {
    error NotAllowed();
    error NaffleNotCancelled(NaffleTypes.NaffleStatus status);
    error InvalidTicketId(uint256 ticketId);
    error RefundFailed();
    error NotTicketOwner(address sender);
}
