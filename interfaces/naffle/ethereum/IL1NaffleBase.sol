// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

interface IL1NaffleBase {
    function createNaffle(
        address _ethTokenAddress,
        uint256 _nftId,
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime,
        NaffleTypes.NaffleType _naffleType
    ) external returns (uint256 naffleId, bytes32 txHash);
    function consumeMessageFromL2(
        address _zkSyncAddress,
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external;
    function claimNft(uint256 _naffleId) external;

    error NotSupported();
}
