//SPDX-License-Identifier = MIT
pragma solidity ^0.8.9;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

error CallerIsContract(address address_);
error ExceedingMaxTokensPerWallet(uint16 maxPerWallet);
error ExceedingWhitelistAllowance(uint16 whitelistAllowance);
error InsufficientFunds(uint256 funds, uint256 cost);
error InsufficientSupplyAvailable(uint256 maxSupply);
error InvalidWhitelistId(uint8 whitelistId);
error InvalidWhitelistTime();
error NotWhitelisted();
error ReservedTokensExceedsRemainingSupply(
    uint256 remainingSupply,
    uint16 newReservedTokens
);
error SaleNotActive();
error URIQueryForNonexistentToken();
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
    uint256 public publicMintStartTime;

    string public baseURI = "";
    string public baseExtension = ".json";
    
    // maps whitelist_id / waitlist_id to whitelist object.
    mapping(uint8 => Whitelist) public whitelists;
    mapping(address => uint16) public addressMintCount;
    mapping(address => bool) public whitelistMinted;

    bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
    
    constructor(
        uint16 _maxSupply,
        uint16 _reservedTokens,
        uint16 _maxPerWallet,
        uint256 _mintPrice,
        address _internalMintAddress,
        uint256 _publicMintStartTime
    ) ERC721A("Naffles OmnipotentNFT", "NFLS") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(WITHDRAW_ROLE, msg.sender);
        
        maxSupply = _maxSupply;             
        reservedTokens = _reservedTokens;
        publicMintStartTime = _publicMintStartTime;
        mintPrice = _mintPrice;
        maxPerWallet = _maxPerWallet;

        _mint(_internalMintAddress, _reservedTokens);
    }

    modifier validateMint() {
        if (_totalMinted() == maxSupply) {
            revert InsufficientSupplyAvailable({
                maxSupply: maxSupply
            });
        }
        if (_numberMinted(msg.sender) == maxPerWallet) {
            revert ExceedingMaxTokensPerWallet({
                maxPerWallet: maxPerWallet
            });
        }
        _;
    }
    
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function createWhitelist(
        bytes32 _root, 
        uint8 _whitelist_id, 
        uint256 _startTime, 
        uint256 _endTime) public onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (_whitelist_id != whitelist_id && _whitelist_id != waitlist_id) {
            revert InvalidWhitelistId({whitelistId: _whitelist_id});
        }
        if (_startTime >= publicMintStartTime || _endTime >= publicMintStartTime || _startTime >= _endTime) {
            revert InvalidWhitelistTime();
        }
        whitelists[_whitelist_id] = Whitelist(_root, _startTime, _endTime);
    }

    function removeWhitelist(uint8 _id) public onlyRole(DEFAULT_ADMIN_ROLE) {
        delete whitelists[_id];
    }

    function mint() public payable validateMint nonReentrant {
        if (block.timestamp < publicMintStartTime) {
            revert SaleNotActive();
        }
        _internalMint();
    }

    function whitelistMint(WhitelistProof calldata _proof) public payable validateMint nonReentrant {
        Whitelist memory whitelist = whitelists[_proof.whitelist_id];
        if (block.timestamp >= publicMintStartTime || block.timestamp >= whitelist.endTime || block.timestamp < whitelist.startTime ) {
            revert SaleNotActive();
        }
        _whitelistMint(_proof, whitelist.root);
        _internalMint();
    }

    function _whitelistMint(WhitelistProof calldata _whitelistProof, bytes32 root) internal {
        if (!MerkleProof.verify(_whitelistProof.proof, root, keccak256(abi.encodePacked(msg.sender)))) {
            revert NotWhitelisted();
        }
        if (whitelistMinted[msg.sender]) {
            revert ExceedingWhitelistAllowance({whitelistAllowance: 1});
        }
        whitelistMinted[msg.sender] = true; 
    }

    function _internalMint() internal {
        if (msg.value < mintPrice) { 
            revert InsufficientFunds(msg.value, mintPrice); 
        }

        if (msg.value > mintPrice) {
          uint256 excess = msg.value - mintPrice;
          (bool returned, ) = msg.sender.call{ value: excess }("");
          if (!returned) { revert UnableToSendChange({cashChange: excess}); }
        }

        _mint(msg.sender, 1);
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

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(tokenId)) { 
            revert URIQueryForNonexistentToken();
        }

        return
            bytes(_baseURI()).length != 0
                ? string(
                    abi.encodePacked(baseURI, _toString(tokenId), baseExtension)
                )
                : "";
    }

    function withdraw() external onlyRole(WITHDRAW_ROLE) {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        if (!success) { revert UnableToWithdraw({amount: address(this).balance});}
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _baseExtension)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        baseExtension = _baseExtension;
    }
}

