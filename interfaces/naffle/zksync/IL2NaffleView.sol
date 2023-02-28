// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL2NaffleView {
    function getPlatformFee() external view returns (uint256);
    function getFreeTicketRatio() external view returns (uint256);
    function getL1NaffleContractAddress() external view returns (address);
}