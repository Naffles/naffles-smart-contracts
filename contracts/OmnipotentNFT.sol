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
error InvalidWhitelistId();
error InvalidWhitelistTime();
error NotWhitelisted();
error ReservedTokensExceedsRemainingSupply(
    uint256 remainingSupply,
    uint16 newReservedTokens
);
error SaleNotActive();
error UnableToSendChange(uint256 cashChange);
error UnableToWithdraw(uint256 amount);

contract OmnipotentNFT is ERC721A, AccessControl, ReentrancyGuard {
    using Address for address;

    struct Whitelist {
        bytes32 root;
        uint256 startTime;
        uint256 endTime;
    }

    struct WhitelistProof {
        uint8 whitelist_id;
        bytes32[] proof;
    }

    uint8 public whitelist_id = 1;
    uint8 public waitlist_id = 2;
    uint16 public maxSupply;
    uint16 public reservedTokens;
    uint16 public maxPerWallet;
    uint256 public mintPrice;

    string public baseURI = "";
    
    // maps whitelist_id / waitlist_id to whitelist object.
    mapping(uint8 => Whitelist) public whitelists;
    mapping(address => uint16) public addressMintCount;
    mapping(address => bool public whitelistMinted;

    bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
    
    constructor(
        uint16 _maxSupply,
        uint16 _reservedTokens,
        uint16 _maxPerWallet,
        uint256 _publicMintStartTime
    ) ERC721A("Naffles OmnipotentNFT", "NFLS") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(WITHDRAW_ROLE, msg.sender);
        
        maxSupply = _maxSupply;             
        reservedTokens = _reservedTokens;
        publicMintStartTime = _publicMintStartTime;
        maxPerWallet_ = _maxPerWallet;
    }
    
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function createWhitelist(bytes32 _root, uint8 _whitelist_id, uint256 _startTime, uint256 _endTime) onlyRole(DEFAULT_AMDIN_ROLE)
    {
        if (_id != whitelist_id || _id != waitlist_id) {
            revert InvalidWhitelistId();
        }
        if (_startTime >= publicMintStartTime || endTime >= publicMintStartTime) {
            revert InvalidWhitelistTime();
        }
        whitelists[whitelist_id] = Whitelist(_root, _startTime, _endtime);
    }

    function removeWhitelist(uint16 _id) onlyRole(DEFAULT_ADMIN_ROLE) {
        delete whitelists[_id];
    }

    function mint(WhitelistProof calldata _proof) public payable {
        if (_totalMinted() == maxSupply) {
            revert InsufficientSupplyAvailable({
                maxSupply: maxSupply    
            });
        };
        if (_numberMinter(msg.sender) + 1 >= maxPerWallet) {
            revert ExceedingMaxTokensPerWallet({
                walletLimit: maxPerWallet
            );
        };
        
        if (block.timestamp >= publicMintStartTime) {
            _publicMint(_amount);
        } 
        else if (block.timestamp => _proof.startTime && block.timestamp <= _proof.endTime) {
            _whitelistMint(_proof);
        }
        else {
            revert SaleNotActive();
        }

        _internalMint();
    }

    function 

    function _WhitelistMint(WhitelistProof calldata _whitelistProof) internal {
        if (!MerkleProof.verify(_whitelistProof.proof, whitelists[_whitelistProof.whitelist_id].root, keccak256(abi.encodePacked(msg.sender)))) {
            revert NotWhitelisted();
        }
        if (whietlistMinted[msg.sender]) {
            revert ExceedingWhitelistAllowance({allowance: 1});
        }
        whitelistMinted[msg.sender] = true; 
    }

    function _internalMint() internal {
        if (msg.value < mintPrice) { 
            revert InsufficientFunds(msg.value, mintPrice); 
        }

        if (msg.value > mintPrice) {
          uint256 excess = msg.value - mintPrice;
          (bool returned, ) = payable(_msgSender()).call{ value: excess }("");
          if (!returned) { revert UnableToSendChange(); }
        }

        _mint(msg.sender, _amount);
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
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        if (!success) {
            revert UnableToWithdraw({amount: address(this).balance});
        }
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

