// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface ITestValueFacet {
    function getValue() external view returns (string memory);
    function setValue(string memory value) external;
}
