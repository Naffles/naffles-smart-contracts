// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@matterlabs/zksync-contracts/l1/contracts/zksync/interfaces/IMailbox.sol";

contract ETHZkSyncMock is IMailbox {
    bool public called = false;
    bool proveL2MessageInclusionResult = true;
    bool proveL2LogInclusionResult = true;
    bool proveL1ToL2TransactionStatusResult = true;


    constructor(
        bool _proveL2MessageInclusionResult,
        bool _proveL2LogInclusionResult,
        bool _proveL1ToL2TransactionStatusResult
    ) {
        proveL2MessageInclusionResult = _proveL2MessageInclusionResult;
        proveL2LogInclusionResult = _proveL2LogInclusionResult;
        proveL1ToL2TransactionStatusResult = _proveL1ToL2TransactionStatusResult;
    }

    function proveL2MessageInclusion(
        uint256 _blockNumber,
        uint256 _index,
        L2Message calldata _message,
        bytes32[] calldata _proof
    ) external view returns (bool) {
        return proveL2MessageInclusionResult;
    }

    function proveL2LogInclusion(
        uint256 _blockNumber,
        uint256 _index,
        L2Log memory _log,
        bytes32[] calldata _proof
    ) external view returns (bool) {
        return proveL2LogInclusionResult;
    }

    function proveL1ToL2TransactionStatus(
        bytes32 _l2TxHash,
        uint256 _l2BlockNumber,
        uint256 _l2MessageIndex,
        uint16 _l2TxNumberInBlock,
        bytes32[] calldata _merkleProof,
        TxStatus _status
    ) external view returns (bool) {
        return proveL1ToL2TransactionStatusResult;
    }

    function serializeL2Transaction(
        uint256 _txId,
        uint256 _l2Value,
        address _sender,
        address _contractAddressL2,
        bytes calldata _calldata,
        uint256 _l2GasLimit,
        uint256 _l2GasPerPubdataByteLimit,
        bytes[] calldata _factoryDeps,
        uint256 _toMint,
        address _refundRecipient
    ) external pure returns (L2CanonicalTransaction memory) {
        revert("Not implemented");
    }

    function finalizeEthWithdrawal(
        uint256 _l2BlockNumber,
        uint256 _l2MessageIndex,
        uint16 _l2TxNumberInBlock,
        bytes calldata _message,
        bytes32[] calldata _merkleProof
    ) external {
        revert("Not implemented");
    }

    function requestL2Transaction(
        address _contractL2,
        uint256 _l2Value,
        bytes calldata _calldata,
        uint256 _l2GasLimit,
        uint256 _l2GasPerPubdataByteLimit,
        bytes[] calldata _factoryDeps,
        address _refundRecipient
    ) external payable returns (bytes32 canonicalTxHash) {
        called = true;
        return(bytes32(0));
    }

    function l2TransactionBaseCost(
        uint256 _gasPrice,
        uint256 _l2GasLimit,
        uint256 _l2GasPerPubdataByteLimit
    ) external view returns (uint256) {
        revert("Not implemented");
    }
}
