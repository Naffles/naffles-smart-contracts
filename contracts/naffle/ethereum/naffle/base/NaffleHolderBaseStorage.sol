// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {NaffleTypes} from "../../../../libraries/NaffleTypes.sol";

library NaffleHolderBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.ethereum.naffle.base.NaffleHolderBaseStorage");

    struct Layout{
        address zkSyncAddress;
        address zkSyncNaffleContractAddress;
        uint256 numberOfNaffles;
        uint256 minimumNaffleDuration;
        uint256 minimumPaidTicketSpots;
        mapping(uint256 => NaffleTypes.NaffleHolder) naffles;
        mapping(uint256 => address) naffleWinner;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}
