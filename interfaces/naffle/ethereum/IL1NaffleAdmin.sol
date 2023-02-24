// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface INaffleAdmin {
    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) internal;
    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) internal;
    function setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) internal;
    function setZkSyncAddress(address _zkSyncAddress) internal;
    function setFoundersKeyAddress(address _foundersKeyAddress) internal;
    function setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) internal;
}