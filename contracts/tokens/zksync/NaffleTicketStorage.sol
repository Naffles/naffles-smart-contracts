// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library TestValueStorage {
    bytes32 internal constant STORAGE_SLOT = keccak256("naffles.contracts.tokens.zksync.NaffleTicketStorage");

    struct Storage {
        uint256 baseURI;
    }

    function layout() internal pure returns (Storage storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}
