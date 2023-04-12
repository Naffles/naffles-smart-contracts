// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import '@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol';
import "../../interfaces/tokens/ITokenURIInternal.sol";

abstract contract TokenURIInternal is ITokenURIInternal {
    function _tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(tokenId)) {
            revert URIQueryForNonexistentToken();
        }

        return
        bytes(ERC721MetadataStorage.layout().baseURI).length != 0
        ? string(
            abi.encodePacked(baseURI, _toString(tokenId), ".json")
        )
        : "";
    }

    function _setBaseURI(string memory _baseURI) internal {
        ERC721MetadataStorage.layout().baseURI = _baseURI;
    }
}
