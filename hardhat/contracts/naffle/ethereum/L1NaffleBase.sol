// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L1NaffleBaseInternal.sol";
import "../../libraries/NaffleTypes.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/interfaces/IERC721Receiver.sol";
import "@solidstate/contracts/interfaces/IERC1155Receiver.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleBase.sol";


contract L1NaffleBase is IL1NaffleBase, L1NaffleBaseInternal, AccessControl, IERC721Receiver, IERC1155Receiver {
    /**
     * @inheritdoc IL1NaffleBase
     */
    function createNaffle(
        NaffleTypes.NaffleTokenInformation calldata _naffleTokenInformation,
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime,
        NaffleTypes.NaffleType _naffleType,
        NaffleTypes.L2MessageParams calldata _l2MessageParams,
        NaffleTypes.CollectionWhitelistParams memory _collectionWhitelistParams
    ) external payable returns (uint256 naffleId, bytes32 txHash) {
        return _createNaffle(
            _naffleTokenInformation,
            _paidTicketSpots,
            _ticketPriceInWei,
            _endTime,
            _naffleType,
            _l2MessageParams,
            _collectionWhitelistParams
        );
    }

    function cancelFailedNaffle(
        uint256 _naffleId,
        uint256 _l2BlockNumber,
        uint256 _l2MessageIndex,
        uint16 _l2TxNumberInBlock,
        bytes32[] calldata _merkleProof
    ) external {
        _cancelFailedNaffle(
            _naffleId,
            _l2BlockNumber,
            _l2MessageIndex,
            _l2TxNumberInBlock,
            _merkleProof
        );
    }

    /**
     * @inheritdoc IL1NaffleBase
     */
    function consumeSetWinnerMessage(
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes32 _messageHash,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external {
        _consumeMessageFromL2(
            _l2BlockNumber,
            _index,
            _l2TxNumberInBlock,
            _messageHash,
            _message,
            _proof
        );
        (NaffleTypes.ActionType action, uint256 naffleId, address winner) = abi.decode(_message, (NaffleTypes.ActionType, uint256, address));
        require(action == NaffleTypes.ActionType.SET_WINNER);
        _setWinnerAndTransferPrize(naffleId, winner);
    }

    /**
     * @inheritdoc IL1NaffleBase
     */
    function consumeCancelMessage(
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes32 _messageHash,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external {
        _consumeMessageFromL2(
            _l2BlockNumber,
            _index,
            _l2TxNumberInBlock,
            _messageHash,
            _message,
            _proof
        );
        (NaffleTypes.ActionType action, uint256 naffleId) = abi.decode(_message, (NaffleTypes.ActionType , uint256));
        require(action == NaffleTypes.ActionType.CANCEL);
        _cancelNaffle(naffleId);
    }
    /**
     * @inheritdoc IERC721Receiver
     */
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return
            bytes4(
                keccak256('onERC721Received(address,address,uint256,bytes)')
            );
    }

    /**
     * @inheritdoc IERC1155Receiver
     */
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return
            bytes4(
                keccak256('onERC1155Received(address,address,uint256,uint256,bytes)')
            );
    }


    /**
     * @inheritdoc IERC1155Receiver
     */
    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure override returns (bytes4) {
        revert NotSupported();
    }

    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        return interfaceId == type(IERC721Receiver).interfaceId || interfaceId == type(IERC1155Receiver).interfaceId;
    }
}
