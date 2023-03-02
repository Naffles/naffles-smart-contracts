// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

interface IL2OpenEntryTicketView {
    function getAdminRole() external view returns (bytes32);
    function getTotalSupply() external view returns (uint256);
}