// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../libraries/NaffleTypes.sol";

library L2NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.zksync.L2NaffleBaseStorage");

    struct Layout {
        address l1NaffleContractAddress;
        // 100 = 1%
        uint256 freeTicketRatio;
        uint256 platformFee;
        mapping(uint256 => NaffleTypes.L2Naffle) naffles;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

