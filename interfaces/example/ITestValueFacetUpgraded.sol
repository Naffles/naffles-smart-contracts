// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ITestValueFacetUpgraded {
    function getValue() external view returns (string memory);
    function setValue(string memory value) external;
    function getSecondValue() external view returns (string memory);
    function setSecondValue(string memory value) external;
}

