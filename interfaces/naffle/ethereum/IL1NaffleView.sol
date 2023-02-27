// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IL1NaffleView {
    function getMinimumNaffleDuration() external view returns (uint256);
    function getMinimumPaidTicketSpots() external view returns (uint256);
    function getMinimumPaidTicketPrice() external view returns (uint256);
    function getZkSyncNaffleContractAddress() external view returns (address);
    function getZkSyncAddress() external view returns (address);
    function getFoundersKeyAddress() external view returns (address);
    function getFoundersKeyPlaceholderAddress() external view returns (address);
    function getAdminRole() external view returns (bytes32);
}