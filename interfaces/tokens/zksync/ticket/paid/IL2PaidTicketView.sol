// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL2PaidTicketView {
    function getAdminRole() external view returns (bytes32);
    function getL2NaffleContractAddress() external view returns (address);
}