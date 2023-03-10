// SPDX-License-Identifier: UNLICENSED
// OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol" as OpenZeppelin;

contract ERC1967Proxy is OpenZeppelin.ERC1967Proxy {
    constructor(address _logic, bytes memory _data) payable OpenZeppelin.ERC1967Proxy(_logic, _data) {}
}
