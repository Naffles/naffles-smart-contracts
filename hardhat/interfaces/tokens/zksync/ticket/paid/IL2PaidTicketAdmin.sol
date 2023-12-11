// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/**
 * @title interface for L2PaidTicketAdmin
 */
interface IL2PaidTicketAdmin {

    /**
     * @notice set the admin role.
     * @param _admin the address of the admin.
     */
    function setAdmin(address _admin) external;

    /**
     * @notice set the address of the L2 Naffle contract.
     * @param _l2NaffleContractAddress the address of the L2 Naffle contract.
     */
    function setL2NaffleContractAddress(address _l2NaffleContractAddress) external;

    /**
     * @notice set the base URI.
     * @param _baseURI the base URI.
     */
    function setBaseURI(string memory _baseURI) external;

    /**
     * @notice remove the admin role.
     * @param _admin the address of the admin.
     */
    function removeAdmin(address _admin) external;
}
