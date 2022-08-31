//SPDX-License-Identifier = MIT
pragma solidity ^0.8.9;

import "erc721a/contracts/ERC721A.sol";
import "openzeppelin/contracts/AccessControl";
import "openzeppelin/contracts/ReentrancyGuard.sol";
import "openzeppelin/contracts/utils/Address";
import "openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

error CallerIsContract(address address_);
error ExceedingMaxTokensPerWallet(uint16 maxPerWallet);
error ExceedingWhitelistAllowance(uint16 whitelistAllowance);
error InsufficientFunds(uint256 funds, uint256 cost);
error InsufficientSupplyAvailable(uint256 availableSupply);
error NonPositiveMintAmount(uint16 amount);
error NotWhitelisted();
error ReservedTokensExceedsRemainingSupply(
    uint256 remainingSupply,
    uint16 newReservedTokens
);
error UnableToSendChange(uint256 cashChange);
error UnableToWithdraw(uint256 amount);

contract OmnipotentNFT is ERC721A, AccessControl, ReentrancyGuard {
    using Address for address;

    struct Whitelist {
        bytes32 root;
        uint16 allocation;
    } 

    struct WhitelistProof {
        uint16 allowance;
        bytes32[] proof;
    }

    uint16 public maxSupply;
    uint16 public reservedTokens;
    uint16 public maxPerWallet;
    uint256 public mintPrice;
    uint256 public whitelistMintStartTime;

    string public baseURI = "";
    
    // Maps allowance count to the whitelist object.
    mapping(uint16 => Whitelist) public whitelists;
    mapping (address => uint16) public addressMintCount;

    bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
    
    constructor(
        uint16 _maxSupply,
        uint16 _reservedTokens,
        uint16 _maxPerWallet,
        uint256 _whitelistMintStartTime,
        uint256 _publicMintStartTime
    ) ERC721A("Naffles OmnipotentNFT", "NFLS") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(WITHDRAW_ROLE, msg.sender);
        
        maxSupply = _maxSupply;             
        reservedTokens = _reservedTokens;
        whitelistMintStartTime = _whitelistMintStartTime;
        publicMintStartTime = _publicMintStartTime;
        maxPerWallet_ = _maxPerWallet;
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

    function mint(uint16 _amount, bytes32[] calldata _proof) public payable {
        if (_amount < 1) { 
            revert NonPostivieMintAmount({
                amount: _amount
            });
        };
        if (_numberMinter(msg.sender) + _amount >= maxPerWallet) {
            revert ExceedingMaxTokensPerWallet({
                walletLimit: maxPerWallet
            );
        };
        if (_amount + _totalMinted() > maxSupply) {
            revert InsufficientSupplyAvailable({
                maxSupply: maxSupply    
            });
        };

        if (block.timestamp >= starttime) {
            publicMint(_amount);
        } else {
            whitelistMint(_amount, _proof);
        }
    }

    function whitelistMint(uint16 _amount, WhitelistProof calldata _whitelistProof) internal {
        if (!MerkleProof.verify(_whitelistProof.proof, whitelists[_whitelistProof.allowance].root, keccak256(abi.encodePacked(msg.sender)))) {
            revert NotWhitelisted()
        }

        if (_numberMinted(msg.sender) + _amount > _whitelist.allowance) {
            revert ExceedingWhitelistAllowance({allowance: _whitelist.allowance});
        }
    }

    function publicMint(uint256 _amount) internal {
        uint256 totalCharge = mintPrice * _amount;
        if (msg.value < totalCharge) { revert InsufficientFunds(msg.value, mintPrice); }

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

