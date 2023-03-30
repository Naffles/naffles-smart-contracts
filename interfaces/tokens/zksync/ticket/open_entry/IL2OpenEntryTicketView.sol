// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title Interface for L2 Open Entry Ticket View
 */
interface IL2OpenEntryTicketView {
    /**
     * @notice get admin role
     * @return l2NaffleContractAddress the address of the L2 Naffle contract.
     */
    function getAdminRole() external view returns (bytes32 adminRole);

    /**
     * @notice get the address of the L2 Naffle contract.
     * @return l2NaffleContractAddress the address of the L2 Naffle contract.
     */
    function getL2NaffleContractAddress() external view returns (address l2NaffleContractAddress);

    /**
     * @notice get the total supply of open entry tickets.
     * @return totalSupply the total supply of open entry tickets.
     */
    function getTotalSupply() external view returns (uint256 totalSupply);

    /**
     * @notice get open entry ticket by id
     * @param _ticketId the id of the ticket.
     * @return ticket the open entry ticket.
     */
    function getOpenEntryTicketById(uint256 _ticketId) external view returns (NaffleTypes.OpenEntryTicket memory ticket);

    /**
     * @notice get the owner of a ticket on a naffle.
     * @param _naffleId the id of the naffle.
     * @param _ticketIdOnNaffle the id of the ticket on the naffle (so not the ticket id).
     * @return owner the owner of the ticket.
     */
    function getOwnerOfNaffleTicketId(uint256 _naffleId, uint256 _ticketIdOnNaffle) external view returns (address owner);
}