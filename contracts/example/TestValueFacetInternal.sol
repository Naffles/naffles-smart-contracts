// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./TestValueStorage.sol";

contract TestValueFacetInternal {
  function _setValue(string memory value) internal {
    TestValueStorage.layout().value = value;
  }

  function _getValue() internal view returns (string memory) {
    return TestValueStorage.layout().value;
  }
}
