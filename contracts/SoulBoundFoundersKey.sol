// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@ERC721A/contracts/interfaces/IERC721A.sol";

error SouldBound();
error AlreadyMinted(uin256 tokenId);
error NotOwnerOfToken(uint256 tokenId);

contract SoulBoundFoundersKey ERC721, Ownable, AccessControl {
    using Address for address;
    address public foundersKeysAddress;
    bytes32 public constant STAKING_CONTRACT_ROLE = keccak256("STAKING_CONTRACT");

    Event Minted(uint256 tokenId, address owner);
    Event Burned(uint256 tokenId);
    
    constructor(address _stakingAddress, address _foundersKeysAddress) ERC721("Souldbound Naffles Founders Keys", "SBNFLS") {
      foundersKeysAddress = _foundersKeysAddress;
      _setupRole(STAKING_CONTRACT_ROLE, _stakingAddress);
    }

    function safeMint(address _to, uint256 _tokenId) public onlyRole(STAKING_CONTRACT_ROLE) {
      if (IERC721A(foundersKeysAddress).ownerOf(_tokenId) != _to) {
        revert NotOwnerOfToken(_tokenId);
      };
      _safeMint(_to, _tokenId);

      emit Minted(_tokenId, _to);
    }

    function burn(uint256 _tokenId) external onlyRole(STAKING_CONTRACT) {
      _burn(_tokenId);

      emit Burned(_tokenId);
    }
  
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
      internal
      virtual
      override(ERC721)
    {
      if(from != address(0) || to != address(0)) {
        revert Souldbound();
      }
      super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721) {
      super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
      return IERC721A(foundersKeysAddress).tokenURI(tokenId);
    }

    function setFoundersKeysAddress(address _foundersKeysAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
      foundersKeysAddress = _foundersKeysAddress;
    }
}
