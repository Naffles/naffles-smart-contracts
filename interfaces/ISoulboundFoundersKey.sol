// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

interface ISoulboundFoundersKey {
    function safeMint(address _to, uint256 _tokenId) external;
    function burn(uint256 _tokenId) external;
}
