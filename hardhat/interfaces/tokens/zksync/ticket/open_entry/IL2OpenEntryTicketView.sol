// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title Interface for L2 Open Entry Ticket View
 */
interface IL2OpenEntryTicketView {
    /**
     * @notice get admin role
     * @return adminRole the admin role.
     */
    function getAdminRole() external view returns (bytes32 adminRole);

    /**
     * @notice get the address of the L2 Naffle contract.
     * @return l2NaffleContractAddress the address of the L2 Naffle contract.
     */
    function getL2NaffleContractAddress() external view returns (address l2NaffleContractAddress);

    /**
     * @notice get open entry ticket by id
     * @param _ticketId the id of the ticket.
     * @return ticket the open entry ticket.
     */
    function getOpenEntryTicketById(uint256 _ticketId) external view returns (NaffleTypes.OpenEntryTicket memory ticket);

    /**
     * @notice gets the signature signer.
     * @return signatureSigner the signature signer.
     */
    function getSignatureSigner() external view returns (address);

    /**
     * @notice gets the domain name.
     * @return domainName the domain name.
     */
    function getDomainName() external view returns (string memory);
}
