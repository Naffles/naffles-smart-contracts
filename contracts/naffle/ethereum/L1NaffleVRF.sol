// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "./L1NaffleBaseInternal.sol";

contract L1NaffleVRF is VRFConsumerBaseV2, L1NaffleBaseInternal {
    constructor(address _vrfCoordinator) VRFConsumerBaseV2(_vrfCoordinator) {}




}
