// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract IL1NaffleVRF {
    function consumeDrawWinnerMessage(
        address _zkSyncAddress,
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external;
}
