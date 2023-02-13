// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../../../../../interfaces/tokens/zksync/tickets/paid/base/IPaidTicketBase.sol";
import { AccessControl } from "@solidstate/contracts/access/acess_control/AccessControl.sol";

contract PaidTicketBaseFacet in AccessControl, PaidTicketBaseInternal, IPaidTicketBase {

  function initialize(address _naffleContract, address _admin) external {
    _setNaffleContract(_naffleContract);
    _grantRole(_getAdminRole(), _admin);
  }

  function setNaffleContract(address _naffleContract) external OnlyRole(_getAdminRole()) {
     _setNaffleContract(_naffleContract);
   }

   function getNaffleContract() external view returns (address) {
     return _getNaffleContract();
   }
  
   function getAdminRole() external view returns (bytes32) {
     return _getAdminRole();
   }
}


