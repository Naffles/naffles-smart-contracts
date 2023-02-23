// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {L1NaffleBaseInternal} from "./L1NaffleBaseInternal.sol";
import {NaffleTypes} from "../../../libraries/NaffleTypes.sol";

abstract contract L1NaffleBase is L1NaffleBaseInternal {

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
}
