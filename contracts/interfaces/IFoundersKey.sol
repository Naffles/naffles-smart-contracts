// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IFoundersKey {
    function tokenType(uint16 _tokenId) external view returns(uint8);
}