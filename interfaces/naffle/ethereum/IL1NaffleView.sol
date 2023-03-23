// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

interface IL1NaffleView {
    function getMinimumNaffleDuration() external view returns (uint256);
    function getMinimumPaidTicketSpots() external view returns (uint256);
    function getMinimumPaidTicketPriceInWei() external view returns (uint256);
    function getZkSyncNaffleContractAddress() external view returns (address);
    function getZkSyncAddress() external view returns (address);
    function getFoundersKeyAddress() external view returns (address);
    function getFoundersKeyPlaceholderAddress() external view returns (address);
    function getAdminRole() external view returns (bytes32);
    function getNaffleById(uint256 _id) external view returns (NaffleTypes.L1Naffle memory);
}