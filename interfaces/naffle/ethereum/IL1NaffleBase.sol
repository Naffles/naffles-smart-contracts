// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";


/**
 * @title interface for L1 Naffle Base.
 */
interface IL1NaffleBase {
    /**
     * @notice create a new naffle, approval for the token is required.
     * @param _naffleTokenInformation naffle token information.
     * @param _paidTicketSpots number of paid ticket spots.
     * @param _ticketPriceInWei price of a ticket in wei.
     * @param _endTime end time of the naffle.
     * @param _naffleType type of the naffle.
     * @param _collectionSignatureParams collection signature parameters.
     * @return naffleId id of the naffle.
     * @return txHash hash of the transaction message to zkSync.
     */
    function createNaffle(
        NaffleTypes.NaffleTokenInformation calldata _naffleTokenInformation,
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime,
        NaffleTypes.NaffleType _naffleType,
        NaffleTypes.L2MessageParams calldata _l2MessageParams,
        NaffleTypes.CollectionSignatureParams calldata _collectionSignatureParams
    ) external payable returns (uint256 naffleId, bytes32 txHash);

    /**
     * @notice consumes the setWinner message from ZkSync, sends the NFT to the winner.
     * @param _l2BlockNumber block number of the L2 block.
     * @param _index index of the message in the block.
     * @param _l2TxNumberInBlock transaction number in the block.
     * @param _messageHash the hashed message send by L2
     * @param _message message to consume.
     * @param _proof proof of the message.
     */
    function consumeSetWinnerMessage(
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes32 _messageHash,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external;

    /**
     * @notice consumes the setWinner message from ZkSync, sends the NFT to the winner.
     * @param _l2BlockNumber block number of the L2 block.
     * @param _index index of the message in the block.
     * @param _l2TxNumberInBlock transaction number in the block.
     * @param _messageHash the hashed message send by L2
     * @param _message message to consume.
     * @param _proof proof of the message.
     */
    function consumeCancelMessage(
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes32 _messageHash,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external;

    /**
     * Thrown when the call is not supported.
     */
    error NotSupported();
}
