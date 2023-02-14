// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { INaffleBase } from "../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";
import { AccessControl } from "@solidstate/contracts/access/acess_control/AccessControl.sol";
import { NaffleBaseInternal } from "./NaffleBaseInternal.sol";

contract NaffleBase in AccessControl, NaffleBaseInternal, INaffleBase {
    function initialize(address _PaidTicketContract, address _admin) external {
        _grantRole(_getAdminRole(), _admin);
        _setPaidTicketContract(_PaidTicketContract);
    }

    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }

    function getOwner() external view returns (address) {
        return _owner();
    }

    function setPaidTicketContract(address _paidTicketContract) external OnlyRole(_getAdminRole()) {
        _setPaidTicketContract(_paidTicketContract);
    }

    function buyTickets(uint256 _amount) external payable returns(uint256[] memory) {
        return _buyTickets(_amount);
    }
}

