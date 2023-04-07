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
        address _ethTokenAddress,
        uint256 _nftId,
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime,
        NaffleTypes.NaffleType _naffleType
    ) external returns (uint256 naffleId, bytes32 txHash) {
        return _createNaffle(
            _ethTokenAddress,
            _nftId,
            _paidTicketSpots,
            _ticketPriceInWei,
            _endTime,
            _naffleType
        );
    }

    /**
     * @inheritdoc IL1NaffleBase
     */
    function consumeSetWinnerMessage(
        address _zkSyncAddress,
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external {
        _consumeMessageFromL2(
            _zkSyncAddress,
            _l2BlockNumber,
            _index,
            _l2TxNumberInBlock,
            _message,
            _proof
        );
        (string memory action, uint256 naffleId, address winner) = abi.decode(_message, (string, uint256, address));
        if (keccak256(abi.encode(action)) == keccak256(abi.encode("setWinner"))) {
            _setWinnerAndTransferNFT(naffleId, winner);
        } else {
            revert InvalidAction();
        }
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