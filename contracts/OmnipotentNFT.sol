//SPDX-License-Identifier = MIT
pragma solidity ^0.8.9;

import "erc721a/contracts/ERC721A.sol";
import "openzeppelin/contracts/AccessControl";
import "openzeppelin/contracts/utils/Address";
import "openzeppelin/contracts/ReentrancyGuard.sol";

error ReservedTokensExceedsRemainingSupply(
    uint256 remainingSupply,
    uint16 newReservedTokens
);

contract OmnipotentNFT is ERC721A, AccessControl, ReentrancyGuard {
    using Address for address;

    uint16 public maxSupply;
    uint16 public reservedTokens;
    uint256 public mintPrice;
    uint256 public whitelistMintStartTime;
    string public baseURI = "";
    
    constructor(
        uint16 maxSupply_,
        uint16 reservedTokens_,
        uint256 whitelistMintStartTime_,
        uint256 publicMintStartTime_,
    ) ERC721A("Naffles OmnipotentNFT", "NFLS") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        maxSupply = maxSupply_              
        reservedTokens = reservedTokens_
        whitelistMintStartTime = whitelistMintStartTime_
        publicMintStartTime = publicMintStartTime_
    }
    
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function whitelistMint() {
    }

    function publicMint() {
    }

    function exists(uint32 tokenId) external view returns (bool) {
        return _exists(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721A, AccessControl)
        returns (bool)
    {
        return (ERC721A.supportsInterface(interfaceId) ||
            AccessControl.supportsInterface(interfaceId));
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory newBaseURI)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        baseURI = newBaseURI;
    }
}

