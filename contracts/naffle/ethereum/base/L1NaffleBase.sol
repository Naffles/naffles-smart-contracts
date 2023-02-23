// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {L1NaffleBaseInternal} from "./L1NaffleBaseInternal.sol";
import {NaffleTypes} from "../../../libraries/NaffleTypes.sol";
import { AccessControl } from "@solidstate/contracts/access/access_control/AccessControl.sol";

abstract contract L1NaffleBase is L1NaffleBaseInternal, AccessControl {

    function createNaffle(
        address _ethTokenAddress, 
        address _owner,
        uint256 _nftId, 
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime, 
        NaffleTypes.NaffleType _naffleType
    ) external returns (uint256 naffleId, bytes32 txHash) {
        return _createNaffle(
            _ethTokenAddress, 
            _owner,
            _nftId, 
            _paidTicketSpots,
            _ticketPriceInWei,
            _endTime, 
            _naffleType
        );
    }

    function getMinimumNaffleDuration() external view returns (uint256) {
        return _getMinimumNaffleDuration();
    }

    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external onlyRole(_getAdminRole()) {
        _setMinimumNaffleDuration(_minimumNaffleDuration);
    }

    function getMinimumPaidTicketSpots() external view returns (uint256) {
        return _getMinimumPaidTicketSpots();
    }

    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external onlyRole(_getAdminRole()) {
        _setMinimumPaidTicketSpots(_minimumPaidTicketSpots);
    }

    function getZkSyncNaffleContractAddress() external view returns (address) {
        return _getZkSyncNaffleContractAddress();
    }

    function setZkSyncNaffleContractAddress(address _zksyncNaffleContractAddress) external onlyRole(_getAdminRole()) {
        _setZkSyncNaffleContractAddress(_zksyncNaffleContractAddress);
    }

    function getZkSyncAddress() external view returns (address) {
        return _getZkSyncAddress();
    }

    function setZkSyncAddress(address _zksyncAddress) external onlyRole(_getAdminRole()) {
        _setZkSyncAddress(_zksyncAddress);
    }
}
