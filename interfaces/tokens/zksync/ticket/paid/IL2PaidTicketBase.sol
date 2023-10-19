// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@solidstate/contracts/interfaces/IERC1155.sol";

/**
 * @title interface for L2PaidTicketBase
 */
interface IL2PaidTicketBase is IERC1155 {

    /**
     * @notice mint tickets for a naffle.
     * @dev method is called from the naffle contract.
     * @param _to the address to mint to.
     * @param _amount the amount to mint.
     * @param _naffleId the id of the naffle.
     * @param ticketPriceInWei the price of the ticket in wei.
     * @param startingTicketId the starting ticket id on the naffle.
     */
    function mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 ticketPriceInWei, uint256 startingTicketId) external;

    /**
     * @notice refund and burn a tickets.
     * @dev method is called from the naffle contract.
     * @param _naffleId the id of the naffle.
     * @param _amount the amount of tickets to refund.
     * @param _owner the owner of the tickets.
     */
    function refundAndBurnTickets(uint256 _naffleId, uint256 _amount, address _owner) external;

    /**
     * @notice burn tickets.
     * @dev method is called from the naffle contract.
     * @param _naffleIdis the ids of the naffles.
     * @param _amounts the amounts of tickets to burn.
     * @param _owner the owner of the tickets.
     */
    function burnTickets(uint256[] calldata _naffleIds, uint256[] calldata _amounts, address _owner) external;
}
