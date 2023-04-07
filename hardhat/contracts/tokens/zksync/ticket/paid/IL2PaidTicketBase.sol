// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/**
 * @title interface for L2PaidTicketBase
 */
interface IL2PaidTicketBase {

    /**
     * @notice mint tickets for a naffle.
     * @dev method is called from the naffle contract.
     * @param _to the address to mint to.
     * @param _amount the amount to mint.
     * @param _naffleId the id of the naffle.
     * @param ticketPriceInWei the price of the ticket in wei.
     * @param startingTicketId the starting ticket id on the naffle.
     */
    function mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 ticketPriceInWei, uint256 startingTicketId) external returns (uint256[] memory ticketIds);

    /**
     * @notice refund and burn a ticket.
     * @dev method is called from the naffle contract.
     * @param _naffleId the id of the naffle.
     * @param _naffleTicketId the id of the ticket on the naffle.
     */
    function refundAndBurnTicket(uint256 _naffleId, uint256 _naffleTicketId) external;
}
