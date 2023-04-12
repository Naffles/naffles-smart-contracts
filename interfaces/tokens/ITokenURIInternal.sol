// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract ITokenURIInternal {
    function _tokenURI(uint256 tokenId) public view virtual returns (string memory);
    function _setBaseURI(string memory _baseURI) internal virtual;

    error URIQueryForNonexistentToken();
}
