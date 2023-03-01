// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

interface IL2PaidTicketView {
    function getAdminRole() external view returns (bytes32);
    function getL2NaffleContractAddress() external view returns (address);
    function getTicketById(uint256 _ticketId) external view returns (NaffleTypes.PaidTicket memory);
    function getTicketByIdOnNaffle(uint256 _ticketId, uint256 _naffleId) external view returns (NaffleTypes.PaidTicket memory);
}