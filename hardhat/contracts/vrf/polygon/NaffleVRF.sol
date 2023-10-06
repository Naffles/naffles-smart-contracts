//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleBase.sol";
import "../../../interfaces/vrf/polygon/INaffleVRF.sol";

contract NaffleVRF is INaffleVRF, VRFConsumerBaseV2, Ownable {
    error NotAllowed();
    error NaffleAlreadyRolled(uint256 naffleId);
    error InvalidChainlinkRequestId(uint256 requestId);

    event NaffleWinnerRolled(uint256 indexed naffleId);
    event ChainlinkRequestFulfilled(uint256 indexed requestId, uint256 indexed naffleId, uint256 winningNumber);

    VRFCoordinatorV2Interface public COORDINATOR;

    uint64 public chainlinkVRFSubscriptionId;
    uint32 public chainlinkVRFCallbackGasLimit;
    uint16 public chainlinkVRFRequestConfirmations;
    bytes32 public chainlinkVRFGasLaneKeyHash;

    address public VRFManager;

    // RequestId -> ChainlinkRequestStatus
    mapping(uint256 => ChainlinkRequestStatus) public chainlinkRequestStatus;
    mapping(uint256 => uint256) public naffleIdToChainlinkRequestId;

    struct ChainlinkRequestStatus {
        bool fulfilled;
        bool exists;
        uint256 randomNumber;
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
        VRFManager = msg.sender;
    }

    modifier onlyVRFManager() {
        if (msg.sender != VRFManager) {
            revert NotAllowed();
        }
        _;
    }

    /*
     * @inheritdoc INaffleVRF
     */
    function drawWinner(uint256 _naffleId) external onlyVRFManager {
        uint256 prevRequestId = naffleIdToChainlinkRequestId[_naffleId];

        if (chainlinkRequestStatus[prevRequestId].exists == true) {
            revert NaffleAlreadyRolled(_naffleId);
        }

        uint256 requestId = COORDINATOR.requestRandomWords(
            chainlinkVRFGasLaneKeyHash,
            chainlinkVRFSubscriptionId,
            chainlinkVRFRequestConfirmations,
            chainlinkVRFCallbackGasLimit,
            1
       );
       // storing the chainlink request
       chainlinkRequestStatus[requestId] = ChainlinkRequestStatus({
            fulfilled: false,
            exists: true,
            randomNumber: 0,
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
        status.randomNumber = randomWords[0];

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

    function setVRFManager(address _newVRFManager) public onlyOwner {
        VRFManager = _newVRFManager;
    }

    function getRandomWordForNaffle(uint256 _naffleId) public view returns (uint256) {
        uint256 requestId = naffleIdToChainlinkRequestId[_naffleId];
        return chainlinkRequestStatus[requestId].randomNumber;
    }
}
