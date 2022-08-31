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
error InsufficientFunds(uint256 funds, uint256 cost);
error UnableToSendChange(uint256 cashChange);
error UnableToWithdraw(uint256 amount);
error CallerIsContract(address address_);
error NonPositiveMintAmount(uint32 amount);

contract OmnipotentNFT is ERC721A, AccessControl, ReentrancyGuard {
    using Address for address;

    struct Whitelist {
        bytes32 root;
        uint16 allocation;
    } 

    uint16 public maxSupply;
    uint16 public reservedTokens;
    uint256 public mintPrice;
    uint256 public whitelistMintStartTime;

    string public baseURI = "";
    
    // Maps allocation count to the whitelist object.
    mapping(uint16 => Whitelist) public whitelists;
    mapping (address => uint16) public addressMintCount;

    constructor(
        uint16 maxSupply_,
        uint16 reservedTokens_,
        uint256 whitelistMintStartTime_,
        uint256 publicMintStartTime_,
    ) ERC721A("Naffles OmnipotentNFT", "NFLS") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        maxSupply = maxSupply_;             
        reservedTokens = reservedTokens_;
        whitelistMintStartTime = whitelistMintStartTime_;
        publicMintStartTime = publicMintStartTime_;
    }
    
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function createWhitelist(bytes32 _root, uint16 _allocation) onlyRole(DEFAULT_AMDIN_ROLE)
    {
        whitelists[allocation] = Whitelist(_root, _allocation);
    }

    function removeWhitelist(uint16 _allocation) onlyRole(DEFAULT_ADMIN_ROLE) {
        delete whitelists[allocation];
    }

    function whitelistMint() payable {
         
    }

    function publicMint(uint256 _amount) payable {
        uint256 totalCharge = mintPrice * _amount;
        if (msg.value < totalCharge) { revert InsufficientFunds(msg.value, mintPrice); }

        // Refund the caller's excess payment if they overpaid.
        if (msg.value > totalCharge) {
          uint256 excess = msg.value - totalCharge;
          (bool returned, ) = payable(_msgSender()).call{ value: excess }("");
          if (!returned) { revert UnableToSendChange(); }
        }
    }

    function exists(uint32 tokenId) external view returns (bool) {
        return _exists(tokenId);
    }

    function supportsInterface(bytes4 _interfaceId)
        public
        view
        virtual
        override(ERC721A, AccessControl)
        returns (bool)
    {
        return (ERC721A.supportsInterface(_interfaceId) ||
            AccessControl.supportsInterface(_interfaceId));
    }

    function withdraw() external onlyRole(WITHDRAW_ROLE) {
        payable(msg.sender).transfer(address(this).balance);
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

