// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library TestValueStorageUpgraded {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contract.tests.TestValueStorage");

    struct Storage {
        string value;
        string secondValue;
    }

    function layout() internal pure returns (Storage storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}
