// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ITicketBase {
    function setNaffleContract(address _naffleContract) external;
    function getAdminRole() external view returns (bytes32);
    function mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 _ticketPriceInWei) external returns(uint256[] memory);
    function setWinningTicket(uint256 _naffleId, uint256 _naffleTicketId) external;
}