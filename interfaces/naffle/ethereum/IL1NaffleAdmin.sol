// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IL1NaffleAdmin {
    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external;
    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external;
    function setMinimumPaidTicketPrice(uint256 _minimumPaidTicketPrice) external;
    function setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) external;
    function setZkSyncAddress(address _zkSyncAddress) external;
    function setFoundersKeyAddress(address _foundersKeyAddress) external;
    function setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) external;
    function setAdmin(address _admin) external;
}