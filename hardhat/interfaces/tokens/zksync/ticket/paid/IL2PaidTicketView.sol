// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title interface for L2PaidTicketView
 */
interface IL2PaidTicketView {
    /**
     * @notice get admin role.
     * @return adminRole the admin role.
     */
    function getAdminRole() external view returns (bytes32 adminRole);

    /**
     * @notice get the address of the L2 Naffle contract.
     * @return l2NaffleContractAddress the address of the L2 Naffle contract.
     */
    function getL2NaffleContractAddress() external view returns (address l2NaffleContractAddress);
}
