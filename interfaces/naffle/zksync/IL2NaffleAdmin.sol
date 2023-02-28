// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL2NaffleAdmin {
    function setPlatformFee(uint256 _platformFee) external;
    function setFreeTicketRatio(uint256 _freeTicketRatio) external;
    function setAdmin(address _admin) external;
}