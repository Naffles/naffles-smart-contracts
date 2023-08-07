// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL2PaidTicketAdmin {
    function setAdmin(address _admin) external;
    function setL2NaffleContractAddress(address _l2NaffleContractAddress) external;
}