// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { INaffleBase } from "../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";
import { AccessControl } from "@solidstate/contracts/access/acess_control/AccessControl.sol";
import { NaffleBaseInternal } from "./NaffleBaseInternal.sol";
import { NaffleType } from './NaffleBaseStorage.sol';

contract NaffleBase in AccessControl, NaffleBaseInternal, INaffleBase { 
    constructor(address _PaidTicketContract, address _admin) {
        _grantRole(_getAdminRole(), _admin);
    }

    function createNaffle(
      address _ethTokenAddress, 
      uint256 _nftId, 
      uint256 _paidTicketSpots,
      uint256 _ticketPriceInWei,
      uint256 _endTime, 
      uint256 _numberOfFreeTickets
      NaffleType _naffleType
    ) external onlyRole(_getNafflePlatformRole())
        _createNaffle(
            _ethTokenAddress, 
            _nftId, 
            _paidTicketSpots,
            _ticketPriceInWei,
            _endTime, 
            _numberOfFreeTickets
            _naffleType
        )
    }

    function extendNaffle(uint256 _naffleId, uint256 _newEndTime) external onlyRole(_getNafflePlatformRole()) {
        _extendNaffle(_naffleId, _newEndTime);
    }

    function cancelNaffle(uint256 _naffleId) external onlyRole(_getNafflePlatformRole()) {
        _cancelNaffle(_naffleId);
    }
    
    function getNaffleInfo(uint256 _naffleId) external view returns (NaffleBaseStorage.Naffle memory) {
        return _getNaffleInfo(_naffleId);
    }

    function getFreeTicketRatio(uint256 _naffleId) external view returns (uint256) {
        return _getFreeTicketRatio(_naffleId);
    }

    function setFreeTicketRatio(uint256 _naffleId, uint256 _freeTicketRatio) external onlyRole(_getNafflePlatformRole()) {
        _setFreeTicketRatio(_naffleId, _freeTicketRatio);
    }

    function setPaidTicketContract(address _paidTicketContract) external OnlyRole(_getAdminRole()) {
        _setPaidTicketContract(_paidTicketContract);
    }
    
    function setPlatformFee(uint256 _platformFee) external OnlyRole(_getAdminRole()) {
        _setPlatformFee(_platformFee);
    }

    function buyTickets(uint256 _amount) external payable returns(uint256[] memory) {
        return _buyTickets(_amount);
    }
}

