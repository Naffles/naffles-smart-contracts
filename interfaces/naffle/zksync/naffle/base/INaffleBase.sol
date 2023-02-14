// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface INaffleBase {
    function buyTickets(uint256 _amount, uint256 _naffleId) external payable returns (uint256[] memory);
    function setNafflePaidTicketContract(address _nafflePaidTicketContract) external;
    function getAdminRole() external view returns (bytes32);
    function getOwner() external view returns (address);
}

