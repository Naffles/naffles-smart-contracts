// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IPaidTicketMintInternal {
  function _buyTickets(uint256 _amount, address _naffle) internal;
}
