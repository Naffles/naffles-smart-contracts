// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title interface for L1 Naffle Base.
 */
interface IL1NaffleBase {
    /**
     * @notice create a new naffle, approval for the token is required.
     * @param _ethTokenAddress address of the token the user wants to naffle.
     * @param _nftId id of the NFT.
     * @param _paidTicketSpots number of paid ticket spots.
     * @param _ticketPriceInWei price of a ticket in wei.
     * @param _endTime end time of the naffle.
     * @param _naffleType type of the naffle.
     * @return naffleId id of the naffle.
     * @return txHash hash of the transaction message to zkSync.
     */
    function createNaffle(
        address _ethTokenAddress,
        uint256 _nftId,
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime,
        NaffleTypes.NaffleType _naffleType
    ) external returns (uint256 naffleId, bytes32 txHash);

    /**
     * @notice consumes the setWinner message from ZkSync, sends the NFT to the winner.
     * @param _zkSyncAddress address of the zkSync contract.
     * @param _l2BlockNumber block number of the L2 block.
     * @param _index index of the message in the block.
     * @param _l2TxNumberInBlock transaction number in the block.
     */
    function consumeSetWinnerMessage(
        address _zkSyncAddress,
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external;

    /**
     * Thrown when the call is not supported.
     */
    error NotSupported();
}
