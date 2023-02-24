// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IL1NaffleView {
    function getMinimumNaffleDuration() internal view returns (uint256);
    function getMinimumPaidTicketSpots() internal view returns (uint256);
    function getZkSyncNaffleContractAddress() internal view returns (address);
    function getZkSyncAddress() internal view returns (address);
    function getFoundersKeyAddress() internal view returns (address);
    function getFoundersKeyPlaceholderAddress() internal view returns (address);
}