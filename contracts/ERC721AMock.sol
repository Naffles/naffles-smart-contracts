// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@ERC721A/contracts/ERC721A.sol";

contract ERC721AMock is ERC721A {
    constructor() ERC721A("ERC721A Mock", "ERC721AMOCK") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return "https://example.com";
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }
}

