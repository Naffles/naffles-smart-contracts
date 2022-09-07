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
error tokenDoesNotExist(uint16 tokenId);
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
        uint256 price;
        uint8 allowance;
    }

    struct WhitelistProof {
        uint8 whitelist_id;
        bytes32[] proof;
        uint8 allowance;
    }

    uint8 public constant OMNIPOTENT_FOUNDERS_PASS = 1;
    uint8 public constant EDGE_FOUNDERS_PASS = 2;
    uint8 public constant PLATINUM_FOUNDERS_PASS = 3;
    uint8 public constant BLACK_FOUNDERS_PASS = 4;

    uint8 public whitelist_id = 1;
    uint8 public waitlist_id = 2;
    uint8 public whitelist_founder_mint_id = 3;
    uint8 public waitlist_founder_mint_id = 4;

    // Max amount addresses can mint during the whitelist period.
    uint8 public maxOmnipotentMintPerWlWalet = 1;
    uint8 public maxFoundersMintPerWlWalet = 2;

    // Max amount addresses can mint in total during this phase (Includes wl mints).
    uint8 public maxOmnipotentMintsPerWallet = 2;
    uint8 public maxFoundersMintsPerWallet = 5;


    uint16 public maxOmnipotentSupply = 300;
    uint16 public maxTotalSupply;
    uint16 public reservedTokens;
    uint16 public maxPerWallet;
    uint256 public mintPrice;
    uint256 public omnipotentPublicMintStartTime;
    uint256 public foundersPublicMintStartTime;


    string public baseURI = "";
    string public baseExtension = ".json";
    
    // maps whitelist_id / waitlist_id to whitelist object.
    mapping(uint8 => Whitelist) public whitelists;
    mapping(address => uint8) public addressOmnipotentMintAmountMapping;
    mapping(address => uint8 public addressFoundersMintAmountMapping;

    // maps token id to token type, will be filled after reveal.
    mapping(uint26 => uint8) public tokenTypeMapping;

    bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
    
    constructor(
        uint16 _maxTotalSupply,
        uint16 _reservedTokens,
        uint16 _maxPerWallet,
        uint256 _mintPrice,
        address _internalMintAddress,
        uint256 _omnipotentPublicMintStartTime
        uint256 _founderPublicMintStartTime
    ) ERC721A("Naffles OmnipotentNFT", "NFLS") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(WITHDRAW_ROLE, msg.sender);
        
        maxTotalSupply = _maxTotalSupply;             
        reservedTokens = _reservedTokens;
        omnipotentPublicMintStartTime = _onmipotentPiblicMintStartTime;
        foundersPublicMintStartTime = _foundersPublicMintStartTime;
        mintPrice = _mintPrice;
        maxPerWallet = _maxPerWallet;

        _mint(_internalMintAddress, _reservedTokens);
    }

    modifier validateMint(uint16 _mintAmount, uint16 _maxSupply) {
        if (_totalMinted() + _mintAmount > _maxSupply) {
            revert InsufficientSupplyAvailable({
                maxSupply: _maxSupply
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
        uint256 _endTime, 
        uint16 _allowance) public onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (_whitelist_id != whitelist_id && _whitelist_id != waitlist_id && _whitelist_id != whitelist_founder_mint_id && _whitelist_id != waitlist_founder_mint_id) {
            revert InvalidWhitelistId({whitelistId: _whitelist_id});
        }
        if (_startTime >= publicMintStartTime || _endTime >= publicMintStartTime || _startTime >= _endTime) {
            revert InvalidWhitelistTime();
        }
        whitelists[_whitelist_id] = Whitelist(_root, _startTime, _endTime, allowance);
    }

    function removeWhitelist(uint8 _id) public onlyRole(DEFAULT_ADMIN_ROLE) {
        delete whitelists[_id];
    }

    function omnipotentMint(uint8 _mintAmount) public payable validateMint(_mintAmount, maxOmnipotentSupply) nonReentrant {
        addressOmnipotentMintAmountMapping[msg.sender] += _mintAmount;
        if (addressOmnipotentMintAmountMapping[msg.sender] > maxOmnipotentMintsPerWallet) {
            revert ExceedingMaxTokensPerWallet({
                maxPerWallet: maxOmnipotentMintsPerWallet
            });
        }
        if (block.timestamp < publicOmnipotentMintStartTime) {
            revert SaleNotActive();
        }
        _internalMint(_mintAmount);
    }

    function foundersMint(uint8 _mintAmount) public payable validateMint(_mintAmount, maxTotalSupply) nonReentrant {
        addressFoundersMintAmountMapping[msg.sender] += _mintAmount;
        if (addressFoundersMintAmountMapping[msg.sender] > maxFoundersMintsPerWallet) {
            revert ExceedingMaxTokensPerWallet({
                maxPerWallet: maxFoundersMintsPerWallet
            });
        }
        if (block.timestamp < publicFoundersMintStartTime) {
            revert SaleNotActive();
        }
        _internalMint(_mintAmount, maxTotalSupply);
    }

    function omnipotentWhitelistMint(uint8 _mintAmount, WhitelistProof calldata _proof) public payable validateMint(_mintAmount, maxOmnipotentSupply) nonReentrant {
        Whitelist memory whitelist = whitelists[_proof.whitelist_id];

        if (block.timestamp >= omnipotentPublicMintStartTime || block.timestamp >= whitelist.endTime || block.timestamp < whitelist.startTime ) {
            revert SaleNotActive();
        }

        if (whitelist.id == 1 || whitelist.id == 2) {
            _omnipotentWhitelistMint(_mintAmount);
        } else {
            revert InvalidWhitelistId({whitelistId: _proof.whitelist_id});
        }
        _whitelistCheckAndMint(_mintAmount, _proof);
    }


    function foundersWhitelistMint(uint8 _mintAmount, WhitelistProof calldata _proof) public payable validateMint(_mintAmount, maxTotalSupply) nonReentrant {
        Whitelist memory whitelist = whitelists[_proof.whitelist_id];

        if (block.timestamp >= foundersPublicMintStartTime || block.timestamp >= whitelist.endTime || block.timestamp < whitelist.startTime ) {
            revert SaleNotActive();
        } 

        if (whitelist_id == 3 || whitelist_id == 4) {
            _foundersWhitelistMint(_mintAmount);
        } else {
            revert InvalidWhitelistId({whitelistId: _proof.whitelist_id});
        }
        
        _whitelistCheckAndMint(_mintAmount, _proof);
    }

    function _whitelistCheckAndMint(uint8 _mintAmount, WhitelistProof calldata _proof) internal {
        if (!MerkleProof.verify(_whitelistProof.proof, whitelist.root, keccak256(abi.encodePacked(msg.sender)))) {
            revert NotWhitelisted();
        }

        _internalMint(_mintAmount);
    }

    function _omnipotentWhitelistMint(uint8 _mintAmount) internal {
        addressOmnipotentMintAmountMapping[msg.sender] += _mintAmount;

        if (addressOmnipotentMintAmountMapping[msg.sender] > maxOmnipotentMintPerWlWalet) {
            revert ExceedingWhitelistAllowance({whitelistAllowance: 1});
        }
    }

    function _foundersWhitelistMint(uint8 _mintAmount) internal {
        addressFoundersMintAmountMapping[msg.sender] += _mintAmount;

        if (addressFoundersMintAmountMapping[msg.sender] > maxFoundersMintPerWLWallet) {
            revert ExceedingWhitelistAllowance({whitelistAllowance: 1});
        }
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

    function tokenType(uint16 _tokenId) public view returns(uint8) {
        if (!_exists(tokenId)) { 
            revert TokenDoesNotExist({tokenId: _tokenId});
        }
        if (_tokenId <= maxOmnipotentSupply) {
            return OMNIPOTENT_FOUNDERS_PASS;
        } else {
            return tokenTypeMapping[_tokenId];
        }
    }

    function setBaseURI(string memory _newBaseURI)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        baseURI = _newBaseURI;
    }

    function setTokenTypeMapping(uint8[] _tokenTypes) external onlyRole(DEFAULT_ADMIN_ROLE) {
        startNumber = maxOmnipotentSupply + 1;
        endNumber = startNumber + _tokenTypes.length;
        for (uint8 i = startNumber; i < endNumber; i++) {
            tokenTypeMapping[i] = _tokenTypes[i];
        }
    }

    function setBaseExtension(string memory _baseExtension)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        baseExtension = _baseExtension;
    }
}

