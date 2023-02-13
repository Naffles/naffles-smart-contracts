// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IPaidTicketBaseInternal {
  function _setNaffleContract(address _naffleContract) internal;
  function _getNaffleContract() internal view returns (address);
  function _getAdminRole() internal view returns (bytes32);
}

