// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "../../interfaces/IFoundersKey.sol";
import "@ERC721A/contracts/ERC721A.sol";

contract ERC721AMock is ERC721A, IFoundersKey {
    constructor() ERC721A("ERC721A Mock", "ERC721AMOCK") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721A, IERC721A) returns (string memory) {
        return "https://example.com";
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function tokenType(uint16 tokenId) public pure override returns (uint8) {
        if (tokenId == 1) {
          return 4;
        }
        if (tokenId == 2) {
          return 4;
        }
        if (tokenId == 3) {
          return 3;
        }
        return 0;
    }
}

