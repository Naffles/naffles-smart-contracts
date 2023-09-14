//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

contract VRFCoordinatorV2Mock is VRFCoordinatorV2Interface {
    uint256 private randomNumber;
    uint256 private requestId = 1;
    VRFConsumerBaseV2 private callbackAddress;

    constructor(
        uint256 _randomNumber
    ) {
        randomNumber = _randomNumber;
    }

    function requestRandomWords(
        bytes32 keyHash,
        uint64 subId,
        uint16 requestConfirmations,
        uint32 callbackGasLimit,
        uint32 numWords
    ) public returns (uint256) {
        callbackAddress = VRFConsumerBaseV2(msg.sender);
        requestId++;
        return requestId - 1;
    }

    function callFulfillRandomWords(
        uint256 _requestId
    ) public {
        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = 2;
        callbackAddress.rawFulfillRandomWords(_requestId, randomWords);
    }

    function acceptSubscriptionOwnerTransfer(uint64 subId) external {}

    function addConsumer(uint64 subId, address consumer) external {}

    function cancelSubscription(uint64 subId, address to) external {}

    function createSubscription() external returns (uint64 subId) {return 1;}

    function removeConsumer(uint64 subId, address consumer) external {}

    function requestSubscriptionOwnerTransfer(
        uint64 subId, address newOwner) external {}

    function getRequestConfig()
    external
    view
    override
    returns (
        uint16,
        uint32,
        bytes32[] memory
    )
    {
        revert("not implemented");
    }


    function getSubscription(uint64 subId)
    external
    view
    override
    returns (
        uint96 balance,
        uint64 reqCount,
        address owner,
        address[] memory consumers
    )
    {
        revert("not implemented");
    }

    function pendingRequestExists(uint64 subId) public view override returns (bool) {
        revert("not implemented");
    }
}
