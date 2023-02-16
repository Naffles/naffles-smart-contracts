// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ITicketBase } from "./../../ITicketBase.sol";

interface IFreeTicketBase is ITicketBase {
    function mintTickets(address _to, uint256 _amount, uint256 _naffleId) external returns(uint256[] memory);
}
