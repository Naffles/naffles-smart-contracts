// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/interfaces/IERC721.sol";

interface IFoundersKey is IERC721 {
    function tokenType(uint16 _tokenId) external view returns(uint8);
}
