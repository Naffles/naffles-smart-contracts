// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../../../../../interfaces/tokens/zksync/tickets/paid/base/IPaidTicketBase.sol";
import { AccessControl } from "@solidstate/contracts/access/acess_control/AccessControl.sol";
import { PaidTicketBaseInternal } from "./PaidTicketBaseInternal.sol";
import { Ownable } from "@solidstate/contracts/access/ownable/Ownable.sol";

contract PaidTicketBase in Ownable, AccessControl, PaidTicketBaseInternal, IPaidTicketBase {
    function initialize(address _naffleContract, address _admin) external {
        _setNaffleContract(_naffleContract);
        _grantRole(_getAdminRole(), _admin);
        _setOwner(_admin);
    }

    function mintTickets(address _to, uint256 _amount, uint256 _naffleId) external payable {
        _mintTickets(_to, _amount, _naffleId);
    }

    function setNaffleContract(address _naffleContract) external OnlyRole(_getAdminRole()) {
        _setNaffleContract(_naffleContract);
    }

    function owner() external view returns (address) {
        return _owner();
    }

    function getNaffleContract() external view returns (address) {
        return _getNaffleContract();
    }
    
    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }
}

