// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library NaffleHolderBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.ethereum.naffle.base.NaffleHolderBaseStorage");

    struct Layout{
        uint256 numberOfNaffles;
        // 100 = 1%
        uint256 freeTicketRatio;
        uint256 minimumNaffleDuration;
        mapping(uint256 => NaffleTypes.NaffleHolder) naffles;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}
