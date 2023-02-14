// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../../../../../interfaces/tokens/zksync/tickets/paid/mint/IPaidTicketMint.sol";

contract PaidTicketMint in PaidTicketBaseInternal, IPaidTicketMint {
  function buyTickets(uint256 _amount, uint256 _naffleId) external payable {
    _buyTickets(_amount, _naffleAddress);
  }
}

