// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../libraries/NaffleTypes.sol";

library L1NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.ethereum.L1NaffleBaseStorage");

    struct Layout {
        address zkSyncAddress;
        address zkSyncNaffleContractAddress;
        address foundersKeyAddress;
        address foundersKeyPlaceholderAddress;
        uint256 numberOfNaffles;
        uint256 minimumNaffleDuration;
        uint256 minimumPaidTicketSpots;
        uint256 minimumPaidTicketPriceInWei;
        mapping(uint256 => NaffleTypes.L1Naffle) naffles;
        mapping(uint256 => address) naffleWinner;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

