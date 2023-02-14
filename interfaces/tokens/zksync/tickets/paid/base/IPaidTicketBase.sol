// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IAccessControl } from "@solidstate/contract/access/accesscontrol/IAccessControl"

interface IPaidTicketBase {
    function setNaffleContract(address _naffleContract) external;
    function getNaffleContract() external view returns (address);
    function getAdminRole() external view returns (bytes32);
    function getOwner() external view returns (address);
    function mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 _ticketPriceInWei) external;
}
