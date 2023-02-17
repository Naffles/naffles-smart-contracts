// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { INaffleBase } from "../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";
import { AccessControl } from "@solidstate/contracts/access/acess_control/AccessControl.sol";
import { NaffleBaseInternal } from "./NaffleBaseInternal.sol";
import { NaffleTypes } from '../../../../libraries/NaffleTypes.sol';

contract NaffleBase in AccessControl, NaffleBaseInternal, INaffleBase { 
    constructor(address _admin) {
        _grantRole(_getAdminRole(), _admin);
    }

    function createNaffle(
      address _ethTokenAddress, 
      address _owner,
      uint256 _nftId, 
      uint256 _paidTicketSpots,
      uint256 _ticketPriceInWei,
      uint256 _endTime, 
      NaffleTypes.NaffleType _naffleType
    ) external onlyRole(_getNafflePlatformRole())
        _createNaffle(
            _ethTokenAddress, 
            _owner,
            _nftId, 
            _paidTicketSpots,
            _endTime, 
            _ticketPriceInWei,
            _naffleType
        )
    }

    function selectWinner(uint256 _winningNumber, uint256 _naffleId) external onlyRole(_getNafflePlatformRole()) {
        _selectWinner(winningNumber, _naffleId);
    }

    function postponeNaffle(uint256 _naffleId, NaffleTypes.PostponeTime _postponeTime) external {
        _postponeNaffle(_naffleId, _postponeTime);
    }

    function cancelNaffle(uint256 _naffleId) external onlyRole(_getNafflePlatformRole()) {
        _cancelNaffle(_naffleId);
    }

    function adminCancelNaffle(uint256 _naffleId) external onlyRole(_getAdminRole()) {
        _adminCancelNaffle(_naffleId);
    }
    
    function getNaffleInfo(uint256 _naffleId) external view returns (NaffleTypes.Naffle memory) {
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

