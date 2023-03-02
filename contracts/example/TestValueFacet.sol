// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./TestValueFacetInternal.sol";
import "../../interfaces/example/ITestValueFacet.sol";

contract TestValueFacet is TestValueFacetInternal, ITestValueFacet {
    function getValue() external view returns (string memory) {
        return _getValue();
    }

    function setValue(string memory value) external {
        _setValue(value);
    }
}
