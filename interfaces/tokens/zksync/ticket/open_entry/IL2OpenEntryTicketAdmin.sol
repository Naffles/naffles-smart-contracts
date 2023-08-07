// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/**
 * @title interface for L2OpenEntryTicketAdmin
 */
interface IL2OpenEntryTicketAdmin {
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
     * @notice admin mint of open entry tickets.
     * @param _to the address to mint to.
     * @param _amount the amount to mint.
     */
    function adminMint(address _to, uint256 _amount) external;
    function setBaseURI(string memory _baseURI) external;
}