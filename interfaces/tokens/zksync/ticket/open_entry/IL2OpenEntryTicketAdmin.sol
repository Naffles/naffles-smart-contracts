// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL2OpenEntryTicketAdmin {
    function setAdmin(address _admin) external;
    function setL2NaffleContractAddress(address _l2NaffleContractAddress) external;
    function adminMint(address _to, uint256 _amount) external;
}