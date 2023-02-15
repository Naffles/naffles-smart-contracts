// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./TestValueStorageUpgraded.sol";

contract TestValueFacetInternalUpgraded {
    function _setValue(string memory value) internal {
        TestValueStorageUpgraded.layout().value = value;
    }

    function _getValue() internal view returns (string memory) {
        return TestValueStorageUpgraded.layout().value;
    }

    function _setSecondValue(string memory value) internal {
        TestValueStorageUpgraded.layout().secondValue = value;
    }

    function _getSecondValue() internal view returns (string memory) {
        return TestValueStorageUpgraded.layout().secondValue;
    }
}
