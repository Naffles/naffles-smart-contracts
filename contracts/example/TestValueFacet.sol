// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./TestValueFacetInternal.sol";

contract TestValueFacet is TestValueFacetInternal {
    function getValue() external view returns (string memory) {
        return _getValue();
    }

    function setValue(string memory value) external {
        _setValue(value);
    }
}
