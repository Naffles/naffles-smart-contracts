// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title interface for L2PaidTicketView
 */
interface IL2PaidTicketView {
    /**
     * @notice get admin role.
     * @param ticketId the id of the ticket.
     */
    function getAdminRole() external view returns (bytes32 adminRole);

    /**
     * @notice get the address of the L2 Naffle contract.
     * @return l2NaffleContractAddress the address of the L2 Naffle contract.
     */
    function getL2NaffleContractAddress() external view returns (address l2NaffleContractAddress);

    /**
     * @notice get paid ticket by id.
     * @param _ticketId the id of the ticket.
     * @return ticket the paid ticket.
     */
    function getTicketById(uint256 _ticketId) external view returns (NaffleTypes.PaidTicket memory ticket);

    /**
     * @notice get paid ticket by id on naffle.
     * @param _ticketIdOnNaffle the id of the ticket on the naffle.
     * @param _naffleId the id of the naffle.
     * @return ticket the paid ticket.
     */
    function getTicketByIdOnNaffle(uint256 _ticketIdOnNaffle, uint256 _naffleId) external view returns (NaffleTypes.PaidTicket memory ticket);

    /**
     * @notice get the total supply of paid tickets.
     * @return totalSupply the total supply of paid tickets.
     */
    function getTotalSupply() external view returns (uint256 totalSupply);

    /**
     * @notice get the owner of a ticket on a naffle.
     * @param _naffleId the id of the naffle.
     * @param _ticketIdOnNaffle the id of the ticket on the naffle (so not the ticket id).
     * @return owner the owner of the ticket.
     */
    function getOwnerOfNaffleTicketId(uint256 _naffleId, uint256 _ticketIdOnNaffle) external view returns (address owner);
}