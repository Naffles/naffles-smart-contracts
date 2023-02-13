// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IAccessControl } from "@solidstate/contract/access/accesscontrol/IAccessControl"

interface IPaidTicketMint {
  function buyTickets(uint256 _amount, address naffle) external payable;
}
