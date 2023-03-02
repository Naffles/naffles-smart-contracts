// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL2PaidTicketBase {
    function mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 ticketPriceInWei, uint256 startingTicketId) external returns (uint256[] memory ticketIds);
}
