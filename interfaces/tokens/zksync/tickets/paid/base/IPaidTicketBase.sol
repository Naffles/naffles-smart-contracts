// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IAccessControl } from "@solidstate/contract/access/accesscontrol/IAccessControl"

interface IPaidTicketBase {
  function setNaffleContract(address _naffleContract) external;
  function getNaffleContract() external view returns (address);
}
