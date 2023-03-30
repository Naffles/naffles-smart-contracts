// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title interface for L1NaffleView
 */
interface IL1NaffleView {
    /**
     * @notice get the minimum duration of a naffle.
     * @return minimumNaffleDuration the minimum duration of a naffle.
     */
    function getMinimumNaffleDuration() external view returns (uint256 minimumNaffleDuration);

    /**
     * @notice get the minimum number of paid tickets available for a naffle.
     * @return minimumPaidTicketSpots the minimum number of paid ticket spots available for a naffle.
     */
    function getMinimumPaidTicketSpots() external view returns (uint256 minimumPaidTicketSpots);

    /**
     * @notice get the minimum price of a paid ticket in wei.
     * @return minimumPaidTicketPriceInWei the minimum price of a paid ticket in wei.
     */
    function getMinimumPaidTicketPriceInWei() external view returns (uint256 minimumPaidTicketPriceInWei);

    /**
     * @notice get the address of the L2 zkSync Naffle contract.
     * @return zkSyncNaffleContractAddress the address of the zkSync Naffle contract.
     */
    function getZkSyncNaffleContractAddress() external view returns (address zkSyncNaffleContractAddress);

    /**
     * @notice get the address of the L2 zkSync contract.
     * @return zkSyncAddress the address of the zkSync contract.
     */
    function getZkSyncAddress() external view returns (address zkSyncAddress);

    /**
     * @notice get the address of the Founders Key.
     * @return foundersKeyAddress the address of the Founders Key.
     */
    function getFoundersKeyAddress() external view returns (address foundersKeyAddress);

    /**
     * @notice get the address of the Founders Key Placeholder.
     * @return foundersKeyPlaceholderAddress the address of the Founders Key Placeholder.
     */
    function getFoundersKeyPlaceholderAddress() external view returns (address foundersKeyPlaceholderAddress);

    /**
     * @notice get the admin role.
     * @return adminRole the admin role.
     */
    function getAdminRole() external view returns (bytes32 adminRole);

    /**
     * @notice get a naffle by its id.
     * @param _id the id of the naffle.
     * @return naffle the naffle.
     */
    function getNaffleById(uint256 _id) external view returns (NaffleTypes.L1Naffle memory);
}