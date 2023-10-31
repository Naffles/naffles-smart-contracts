// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L1NaffleBaseStorage.sol";
import "../../libraries/NaffleTypes.sol";
import "../../libraries/Signature.sol";
import '@solidstate/contracts/interfaces/IERC165.sol';
import '@solidstate/contracts/interfaces/IERC721.sol';
import '@solidstate/contracts/interfaces/IERC1155.sol';
import '@solidstate/contracts/interfaces/IERC20.sol';
import '@solidstate/contracts/utils/SafeERC20.sol';
import "@matterlabs/zksync-contracts/l1/contracts/zksync/interfaces/IZkSync.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleBaseInternal.sol";
import "@matterlabs/zksync-contracts/l1/contracts/zksync/Storage.sol";

abstract contract L1NaffleBaseInternal is IL1NaffleBaseInternal {
    using SafeERC20 for IERC20;
    bytes4 internal constant ERC20_INTERFACE_ID = 0x36372b07;
    bytes4 internal constant ERC721_INTERFACE_ID = 0x80ac58cd;
    bytes4 internal constant ERC1155_INTERFACE_ID = 0xd9b67a26;

    /**
     * @notice create a new naffle. When the naffle is created, a message is sent to the L2 naffle contract.
     * @dev function gets called by someone who wants to start a naffle.
     * @dev if the owner does not have a founders key, the owner can't create a naffle and a NotAllowed error is thrown.
     * @dev if the naffle end time is less than the current time + the minimum naffle duration, an InvalidEndTime error is thrown.
     * @dev if the naffle type is unlimited and the paid ticket spots is not 0, an InvalidPaidTicketSpots error is thrown.
     * @dev if the naffle type is standard and the paid ticket spots is less than the minimum paid ticket spots, an InvalidPaidTicketSpots error is thrown.
     * @dev if the token type is not supported an InvalidTokenType error is thrown.
     * @dev if the naffle type is standard and the nft id is 0, an InvalidNftId error is thrown.
     * @param _naffleTokenInformation the naffle token information.
     * @param _paidTicketSpots the number of paid ticket spots.
     * @param _ticketPriceInWei the price of a ticket in wei.
     * @param _endTime the end time of the naffle.
     * @param _naffleType the type of the naffle.
     * @param _collectionWhitelistParams the collection whitelist params.
     * @return naffleId the id of the naffle that is created.
     * @return txHash the hash of the transaction that is sent to the L2 naffle contract.
     */
    function _createNaffle(
        NaffleTypes.NaffleTokenInformation memory _naffleTokenInformation,
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime,
        NaffleTypes.NaffleType _naffleType,
        NaffleTypes.L2MessageParams memory _l2MessageParams,
        NaffleTypes.CollectionWhitelistParams memory _collectionWhitelistParams
    ) internal returns (uint256 naffleId, bytes32 txHash) {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();

        if (block.timestamp > _collectionWhitelistParams.expiresAt) {
            revert InvalidSignature();
        }

        _validateCollectionSignature(
            _naffleTokenInformation,
            _collectionWhitelistParams,
            layout.signatureSigner,
            layout.collectionWhitelistSignature,
            layout.domainName,
            layout.domainSignature
        );

        if (
            IERC721(layout.foundersKeyAddress).balanceOf(msg.sender) == 0 &&
            IERC721(layout.foundersKeyPlaceholderAddress).balanceOf(msg.sender) == 0
        ) {
            revert NotAllowed();
        }

        if (_endTime < block.timestamp + layout.minimumNaffleDuration) {
            revert InvalidEndTime(_endTime);
        }

        ++layout.numberOfNaffles;
        naffleId = layout.numberOfNaffles;
        if (
            (_naffleType == NaffleTypes.NaffleType.UNLIMITED && _paidTicketSpots != 0) ||
            (_naffleType == NaffleTypes.NaffleType.STANDARD && _paidTicketSpots < layout.minimumPaidTicketSpots)
        ) {
            // Unlimited naffles don't have an upper limit on paid or open entry tickets.
            revert InvalidPaidTicketSpots(_paidTicketSpots);
        }

        NaffleTypes.TokenContractType tokenContractType;
        if (_naffleTokenInformation.naffleTokenType == NaffleTypes.TokenContractType.ERC721) {
            tokenContractType = NaffleTypes.TokenContractType.ERC721;
            IERC721(_naffleTokenInformation.tokenAddress).transferFrom(msg.sender, address(this), _naffleTokenInformation.nftId);
        } else if (_naffleTokenInformation.naffleTokenType == NaffleTypes.TokenContractType.ERC1155) {
            tokenContractType = NaffleTypes.TokenContractType.ERC1155;
            IERC1155(_naffleTokenInformation.tokenAddress).safeTransferFrom(msg.sender,  address(this), _naffleTokenInformation.nftId, _naffleTokenInformation.amount, bytes(""));
        } else {
            tokenContractType = NaffleTypes.TokenContractType.ERC20;
            IERC20(_naffleTokenInformation.tokenAddress).safeTransferFrom(msg.sender, address(this), _naffleTokenInformation.amount);
        }

        layout.naffles[naffleId] = NaffleTypes.L1Naffle({
            naffleTokenInformation: _naffleTokenInformation,
            naffleId: naffleId,
            owner: msg.sender,
            winner: address(0),
            cancelled: false
        });

        IZkSync zksync = IZkSync(layout.zkSyncAddress);
        bytes memory data = abi.encodeWithSignature(
        "createNaffle((address,uint256,uint256,uint8),address,uint256,uint256,uint256,uint256,uint8)",
            _naffleTokenInformation,
            msg.sender,
            naffleId,
            _paidTicketSpots,
            _ticketPriceInWei,
            _endTime,
            uint8(_naffleType)
        );

        if(msg.value < layout.minL2ForwardedGasForCreateNaffle) {
            revert InsufficientL2GasForwardedForCreateNaffle();
        }

        txHash = zksync.requestL2Transaction{value: msg.value}(
            layout.zkSyncNaffleContractAddress,
            0,
            data,
            _l2MessageParams.l2GasLimit,
            _l2MessageParams.l2GasPerPubdataByteLimit,
            new bytes[](0),
            msg.sender
        );

        emit L1NaffleCreated(_naffleTokenInformation, naffleId, msg.sender, _paidTicketSpots, _ticketPriceInWei, _endTime, _naffleType);
    }

    /**
     * @notice Validates the collection signature.
     * @dev if the collection signature is invalid, an InvalidSignature error is thrown.
     * @param _naffleTokenInformation the naffle token information.
     * @param _collectionWhitelistParams the collection whitelist params.
     * @param _signatureSigner the signer of the collection signature.
     * @param _collectionWhitelistSignature the collection whitelist signature.
     * @param _domainName the domain name. 
     * @param _domainSignature the domain signature.
     */
    function _validateCollectionSignature(
        NaffleTypes.NaffleTokenInformation memory _naffleTokenInformation,
        NaffleTypes.CollectionWhitelistParams memory _collectionWhitelistParams,
        address _signatureSigner,
        bytes32 _collectionWhitelistSignature,
        string memory _domainName,
        bytes32 _domainSignature
    ) internal pure {
        bytes32 domainSeparator = keccak256(
            abi.encode(
                _domainSignature,
                keccak256(abi.encodePacked(_domainName))
            )
        );

        bytes32 dataHash = keccak256(
            abi.encode(
                _collectionWhitelistSignature,
                _naffleTokenInformation.tokenAddress,
                _collectionWhitelistParams.expiresAt
            )
        );
        
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                dataHash
            )
        );

        address signer = Signature.getSigner(digest, _collectionWhitelistParams.signature);

        if (signer != _signatureSigner) {
            revert InvalidSignature();
        }
    }

    /**
     * @notice set the winner of a naffle and transfer the price to that address.
     * @param _naffleId the id of the naffle.
     * @param _winner the address of the winner.
     */
    function _setWinnerAndTransferPrize(
        uint256 _naffleId,
        address _winner
    ) internal {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        NaffleTypes.L1Naffle storage naffle = layout.naffles[_naffleId];

        NaffleTypes.NaffleTokenInformation memory tokenInfo = naffle.naffleTokenInformation;

        naffle.winner = _winner;
        if (tokenInfo.naffleTokenType == NaffleTypes.TokenContractType.ERC721) {
            IERC721(tokenInfo.tokenAddress).transferFrom(address(this), _winner, tokenInfo.nftId);
        } else if (tokenInfo.naffleTokenType == NaffleTypes.TokenContractType.ERC1155) {
            IERC1155(tokenInfo.tokenAddress).safeTransferFrom(address(this), _winner, tokenInfo.nftId, tokenInfo.amount, bytes(""));
        } else {
            IERC20(tokenInfo.tokenAddress).safeTransfer(_winner, tokenInfo.amount);
        } 

        emit L1NaffleWinnerSet(_naffleId, _winner);
    }

    /**
     * @notice consumes a message from L2. Stores that the message has been processed.
     * @param _l2BlockNumber the block number of the L2 block.
     * @param _index the index of the message in the L2 block.
     * @param _l2TxNumberInBlock the transaction number in the L2 block.
     * @param _messageHash the hashed message send by L2
     * @param _message the message that is consumed.
     * @param _proof the proof of the message.
     */
    function _consumeMessageFromL2(
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes32 _messageHash,
        bytes memory _message,
        bytes32[] memory _proof
    ) internal {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        if (layout.isL2ToL1MessageProcessed[_l2BlockNumber][_index]) {
            revert MessageAlreadyProcessed();
        }

        if (keccak256(_message) != _messageHash) {
            revert FailedMessageInclusion();
        }

        IZkSync zksync = IZkSync(layout.zkSyncAddress);

        L2Message memory l2Message = L2Message({
            sender: layout.zkSyncNaffleContractAddress,
            data: _message,
            txNumberInBlock: _l2TxNumberInBlock
        });

        bool success = zksync.proveL2MessageInclusion(
            _l2BlockNumber,
            _index,
            l2Message,
            _proof
        );
        if (!success) {
            revert FailedMessageInclusion();
        }

        layout.isL2ToL1MessageProcessed[_l2BlockNumber][_index] = true;
    }

    /**
     * @notice cancels a naffle.
     * @param _naffleId the id of the naffle.
     */
    function _cancelNaffle(uint256 _naffleId) internal {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        NaffleTypes.L1Naffle storage naffle = layout.naffles[_naffleId];

        naffle.cancelled = true;

        NaffleTypes.NaffleTokenInformation memory tokenInfo = naffle.naffleTokenInformation;

        if (tokenInfo.naffleTokenType == NaffleTypes.TokenContractType.ERC721) {
            IERC721(tokenInfo.tokenAddress).transferFrom(address(this), naffle.owner, tokenInfo.nftId);
        } else if (tokenInfo.naffleTokenType == NaffleTypes.TokenContractType.ERC1155) {
            IERC1155(tokenInfo.tokenAddress).safeTransferFrom(address(this), naffle.owner, tokenInfo.nftId, tokenInfo.amount, bytes(""));
        } else {
            IERC20(tokenInfo.tokenAddress).safeTransferFrom(address(this), naffle.owner, tokenInfo.amount);
        } 

        emit L1NaffleCancelled(_naffleId);
    }

    /**
     * @notice gets the admin role.
     * @return adminRole the admin role.
     */
    function _getAdminRole() internal pure returns (bytes32 adminRole) {
        adminRole = AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    /**
     * @notice gets the minimum naffle duration.
     * @return minimumNaffleDuration the minimum naffle duration.
     */
    function _getMinimumNaffleDuration() internal view returns (uint256 minimumNaffleDuration) {
        minimumNaffleDuration = L1NaffleBaseStorage.layout().minimumNaffleDuration;
    }

    /**
     * @notice sets the minimum naffle duration.
     * @param _minimumNaffleDuration the minimum naffle duration.
     */
    function _setMinimumNaffleDuration(uint256 _minimumNaffleDuration) internal {
        L1NaffleBaseStorage.layout().minimumNaffleDuration = _minimumNaffleDuration;
    }

    /**
     * @notice gets the minimum paid ticket spots.
     * @return minimumPaidTicketSpots the minimum paid ticket spots.
     */
    function _getMinimumPaidTicketSpots() internal view returns (uint256 minimumPaidTicketSpots) {
        minimumPaidTicketSpots = L1NaffleBaseStorage.layout().minimumPaidTicketSpots;
    }

    /**
     * @notice sets the minimum paid ticket spots
     * @param _minimumPaidTicketSpots the minimum paid ticket spots.
     */
    function _setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) internal {
        L1NaffleBaseStorage.layout().minimumPaidTicketSpots = _minimumPaidTicketSpots;
    }

    /**
     * @notice sets the minimum paid ticket price in wei.
     * @param _minimumPaidTicketPriceInWei the minimum paid ticket price in wei.
     */
    function _setMinimumPaidTicketPriceInWei(uint256 _minimumPaidTicketPriceInWei) internal {
        L1NaffleBaseStorage.layout().minimumPaidTicketPriceInWei = _minimumPaidTicketPriceInWei;
    }

    /**
     * @notice gets the minimum paid ticket price in wei.
     * @return minimumPaidTicketPriceInWei the minimum paid ticket price in wei.
     */
    function _getMinimumPaidTicketPriceInWei() internal view returns (uint256 minimumPaidTicketPriceInWei) {
        minimumPaidTicketPriceInWei = L1NaffleBaseStorage.layout().minimumPaidTicketPriceInWei;
    }

    /**
     * @notice sets the zkSync naffle contract address.
     * @param _zkSyncNaffleContractAddress the zkSync naffle contract address.
     */
    function _setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) internal {
        L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress = _zkSyncNaffleContractAddress;
    }

    /**
     * @notice gets the zkSync naffle contract address.
     * @return zkSyncNaffleContractAddress the zkSync naffle contract address.
     */
    function _getZkSyncNaffleContractAddress() internal view returns (address zkSyncNaffleContractAddress) {
        zkSyncNaffleContractAddress = L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress;
    }

    /**
     * @notice sets the zkSync address.
     * @param _zkSyncAddress the zkSync address.
     */
    function _setZkSyncAddress(address _zkSyncAddress) internal {
        L1NaffleBaseStorage.layout().zkSyncAddress = _zkSyncAddress;
    }

    /**
     * @notice gets the zkSync address.
     * @return zkSyncAddress the zkSync address.
     */
    function _getZkSyncAddress() internal view returns (address zkSyncAddress) {
        zkSyncAddress = L1NaffleBaseStorage.layout().zkSyncAddress;
    }

    /**
     * @notice gets the founders key address.
     * @return foundersKeyAddress the founders key address.
     */
    function _getFoundersKeyAddress() internal view returns (address foundersKeyAddress) {
        foundersKeyAddress = L1NaffleBaseStorage.layout().foundersKeyAddress;
    }

    /**
     * @notice sets the founders key address.
     * @param _foundersKeyAddress the founders key address.
     */
    function _setFoundersKeyAddress(address _foundersKeyAddress) internal {
        L1NaffleBaseStorage.layout().foundersKeyAddress = _foundersKeyAddress;
    }

    /**
     * @notice sets the founders key placeholder address.
     * @param _foundersKeyPlaceholderAddress the founders key placeholder address.
     */
    function _setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) internal {
        L1NaffleBaseStorage.layout().foundersKeyPlaceholderAddress = _foundersKeyPlaceholderAddress;
    }

    /**
     * @notice gets the founders key placeholder address.
     * @return foundersKeyPlaceholderAddress the founders key placeholder address.
     */
    function _getFoundersKeyPlaceholderAddress() internal view returns (address foundersKeyPlaceholderAddress) {
        foundersKeyPlaceholderAddress = L1NaffleBaseStorage.layout().foundersKeyPlaceholderAddress;
    }

    /**
     * @notice gets the L1 messenger address.
     * @return l1MessengerAddress the L1 messenger address.
     */
    function _getL1MessengerAddress() internal pure returns (address l1MessengerAddress) {
        l1MessengerAddress = L1NaffleBaseStorage.L1_MESSENGER_ADDRESS;
    }

    /**
     * @notice sets the signature signer address.
     * @param _signatureSignerAddress the signature signer address.
     */
    function _setSignatureSignerAddress(address _signatureSignerAddress) internal {
        L1NaffleBaseStorage.layout().signatureSigner = _signatureSignerAddress;
    }

    /**
     * @notice gets the naffle by id.
     * @param _naffleId the id of the naffle.
     * @return naffle the naffle.
     */
    function _getNaffleById(uint256 _naffleId) internal view returns (NaffleTypes.L1Naffle memory naffle) {
        naffle = L1NaffleBaseStorage.layout().naffles[_naffleId];
    }

    /**
     * @notice sets minimum gas to be forwarded for L2 transactions in _createNaffle
     * @param _minL2ForwardedGasForCreateNaffle the minimum gas limit to be forwarded for L2 transactions in _createNaffle
     * @dev set the minimum amount of wei this transaction should foward to L2. Should be much higher than the actual cost, since refunds are given
     */
    function _setMinL2ForwardedGas(uint256 _minL2ForwardedGasForCreateNaffle) internal {
        L1NaffleBaseStorage.layout().minL2ForwardedGasForCreateNaffle = _minL2ForwardedGasForCreateNaffle;
    }

    /**
     * @notice sets minimum gas limit foir the L2 transaction in _createNaffle
     * @param _minL2GasLimit the minimum gas limit for the L2 transaction in _createNaffle
     */
    function _setMinL2GasLimit(uint256 _minL2GasLimit) internal {
        L1NaffleBaseStorage.layout().minL2GasLimitForCreateNaffle = _minL2GasLimit;
    }

    /**
     * @notice sets the collection signature
     * @param _collectionSignature the new collection signature.
     */
    function _setCollectionWhitelistSignature(bytes32 _collectionSignature) internal {
        L1NaffleBaseStorage.layout().collectionWhitelistSignature = _collectionSignature;
    }

    /**
     * @notice gets the domain signature.
     * @param _domainSignature the domain signature.
     */
    function _setDomainSignature(bytes32 _domainSignature) internal {
        L1NaffleBaseStorage.layout().domainSignature = _domainSignature;
    }

    /**
     * @notice gets the domain signature.
     * @param _domainName the domain signature.
     */
    function _setDomainName(string memory _domainName) internal {
        L1NaffleBaseStorage.layout().domainName = _domainName;
    }
}
