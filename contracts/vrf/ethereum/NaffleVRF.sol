//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleBase.sol";
import "../../../interfaces/vrf/ethereum/INaffleVRF.sol";

contract NaffleVRF is INaffleVRF, VRFConsumerBaseV2, Ownable {
    error NotAllowed();
    error InvalidChainlinkRequestId(uint256 requestId);

    event NaffleWinnerRolled(uint256 indexed naffleId);
    event ChainlinkRequestFulfilled(uint256 indexed requestId, uint256 indexed naffleId, uint256 winningNumber);

    VRFCoordinatorV2Interface public COORDINATOR;

    uint64 public chainlinkVRFSubscriptionId;
    uint32 public chainlinkVRFCallbackGasLimit;
    uint16 public chainlinkVRFRequestConfirmations;
    bytes32 public chainlinkVRFGasLaneKeyHash;

    // RequestId -> ChainlinkRequestStatus
    mapping(uint256 => ChainlinkRequestStatus) chainlinkRequestStatus;
    mapping(uint256 => uint256) naffleIdToChainlinkRequestId;

    struct ChainlinkRequestStatus {
        bool fulfilled;
        bool exists;
        uint256[] randomWords;
        uint256 naffleId;
    }

     constructor (
        address _vrfCoordinator,
        uint64 _subscriptionId,
        bytes32 _gasLaneKeyHash,
        uint32 _callbackGasLimit,
        uint16 _requestConfirmations
    ) VRFConsumerBaseV2(_vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);
        setChainlinkVRFSettings(_subscriptionId, _gasLaneKeyHash, _callbackGasLimit, _requestConfirmations);
    }

    modifier onlyL1NaffleContract() {
        if (msg.sender != L1NaffleDiamondAddress) {
            revert NotAllowed();
        }
        _;
    }

    /* 
     * @inheritdoc INaffleVRF 
     */
    function drawWinner(uint256 _naffleId) external onlyL1NaffleContract {
        uint256 requestId = COORDINATOR.requestRandomWords(
            chainlinkVRFGasLaneKeyHash,
            chainlinkVRFSubscriptionId,
            chainlinkVRFRequestConfirmations,
            chainlinkVRFCallbackGasLimit,
            1 
       );
       // storing the chainlink request
       chainlinkRequestStatus[requestId] = ChainlinkRequestStatus({
            randomWords: new uint256[](0),
            fulfilled: false,
            exists: true,
            naffleId: _naffleId
        });
        naffleIdToChainlinkRequestId[_naffleId] = requestId;

        emit NaffleWinnerRolled(_naffleId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        ChainlinkRequestStatus storage status = chainlinkRequestStatus[requestId];
        if (!status.exists) {
            revert InvalidChainlinkRequestId(requestId);
        }
        status.fulfilled = true;
        status.randomWords = randomWords;

        emit ChainlinkRequestFulfilled(requestId, status.naffleId, randomWords[0]);
    }

    function setChainlinkVRFSettings(
        uint64 _subscriptionId,
        bytes32 _gasLaneKeyHash,
        uint32 _callbackGasLimit,
        uint16 _requestConfirmations
    ) public onlyOwner {
        chainlinkVRFSubscriptionId = _subscriptionId;
        chainlinkVRFGasLaneKeyHash = _gasLaneKeyHash;
        chainlinkVRFCallbackGasLimit = _callbackGasLimit;
        chainlinkVRFRequestConfirmations = _requestConfirmations;
    }

}
