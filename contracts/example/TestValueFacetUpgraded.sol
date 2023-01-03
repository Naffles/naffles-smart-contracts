// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./TestValueFacetInternalUpgraded.sol";

contract TestValueFacetUpgraded is TestValueFacetInternalUpgraded {
    function getValue() external view returns (string memory) {
        return _getValue();
    }

    function setValue(string memory value) external {
        _setValue(value);
    }

    function getSecondValue() external view returns (string memory) {
        return _getSecondValue();
    }

    function setSecondValue(string memory value) external {
        _setSecondValue(value);
    }
}

