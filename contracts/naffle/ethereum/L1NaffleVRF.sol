// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "./L1NaffleBaseInternal.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleVRF.sol";


contract L1NaffleVRF is IL1NaffleVRF, VRFConsumerBaseV2, L1NaffleBaseInternal {
    constructor (
        address _vrfCoordinator
    ) VRFConsumerBaseV2(_vrfCoordinator) {}


    function drawWinner(uint256 _naffleId, uint256 _totalNumberOfTickets) external {
        (uint256 subscriptionId, bytes32 gasLaneKeyHash, uint32 callbackGasLimit, uint16 requestConfirmations) = _getChainlinkVRFSettings();
        uint256 requestId = requestRandomness(
            callbackGasLimit,
            requestConfirmations,
            1
        );
        _storeChainlinkRequest(_naffleId, requestId, _totalNumberOfTickets);
    }

//    function consumeDrawWinnerMessage(
//        address _zkSyncAddress,
//        uint256 _l2BlockNumber,
//        uint256 _index,
//        uint16 _l2TxNumberInBlock,
//        bytes calldata _message,
//        bytes32[] calldata _proof
//    ) external {
//        (string memory action, uint256 naffleId) = _consumeAdminCancelMessage(
//            _zkSyncAddress,
//            _l2BlockNumber,
//            _index,
//            _l2TxNumberInBlock,
//            _message,
//            _proof
//        );
//        if (keccak256(abi.encode(action)) == keccak256(abi.encode("drawWinner"))) {
//            (uint256 chainLinkRequestId, uint256 subscriptionId, bytes32 gasLaneKeyHash, uint32 callbackGasLimit, uint16 requestConfirmations) = _getChainlinkVRFSettings();
//            uint256 chainLinkRequestId = coordinator.requestRandomWords(
//                gasLaneKeyHash,
//                subscriptionId,
//                requestConfirmations,
//                callbackGasLimit,
//                1
//            );
//            _storeChainlinkRequest(naffleId, chainLinkRequestId);
//        } else {
//            revert InvalidAction();
//        }
//    }

    function fulfillRandomWords(bytes32 requestId, uint256[] memory randomWords) internal override {
        _fulfillRandomWords(requestId, randomWords);
    }
}
