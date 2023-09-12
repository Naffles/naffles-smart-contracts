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
     * @return ticketIds the ids of the tickets on the naffle (so not the total id).
     */
    function mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 ticketPriceInWei, uint256 startingTicketId) external returns (uint256[] memory ticketIds);

    /**
     * @notice burs tickets before refund.
     * @dev method is called from the naffle contract.
     * @param _naffleId the id of the naffle.
     * @param _naffleTicketIds the id of the ticket on the naffle.
     * @param _owner the owner of the tickets.
     */
    function burnTicketsBeforeRefund(uint256 _naffleId, uint256[] memory _naffleTicketIds, address _owner) external;

    /**
     * @notice burn used paid tickets before redeeming open entry tickets.
     * @dev method is called from the naffle contract.
     * @param _naffleId the id of the naffle.
     * @param _paidTicketIds the ids of the paid tickets.
     * @param _owner the owner of the tickets.
     */
    function burnUsedPaidTicketsBeforeRedeemingOpenEntryTickets(uint256 _naffleId, uint256[] memory _paidTicketIds, address _owner) external;
}
