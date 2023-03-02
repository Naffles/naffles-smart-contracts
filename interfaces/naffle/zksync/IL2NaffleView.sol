// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

interface IL2NaffleView {
    function getPlatformFee() external view returns (uint256);
    function getFreeTicketRatio() external view returns (uint256);
    function getL1NaffleContractAddress() external view returns (address);
    function getAdminRole() external view returns (bytes32);
    function getNaffleById(uint256 _id) external view returns (NaffleTypes.L2Naffle memory);
    function getPaidTicketContractAddress() external view returns (address);
    function getOpenEntryTicketContractAddress() external view returns (address);
}