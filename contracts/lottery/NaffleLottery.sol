// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error InvalidStartTime(uint256 startTime);
error InvalidEndTime(uint256 endTime);
error InvalidTicketPrice(uint256 ticketPrice);
error InvalidTokenAddress(address tokenAddress);
error InvalidLotteryId(uint256 lotteryId);
error LotteryHasNotStarted(uint256 lotteryId);
error LotteryHasNotEnded(uint256 lotteryId);
error LotteryHasAlreadyEnded(uint256 lotteryId);
error AlreadyClaimed(uint256 lotteryId, address _address);
error NotElligibleToClaim(uint256 lotteryId, address _address);
error LotteryAlreadyClosed(uint256 lotteryId);

contract NaffleLottery is VRFConsumerBaseV2, KeeperCompatibleInterface, AccessControl, Ownable {
    using SafeERC20 for IERC20;
    VRFCoordinatorV2Interface public coordinator;

    struct Lottery {
        uint256 id;
        uint256 startTime;
        uint256 endTime;
        uint256 ticketPrice;
        uint256 numberOfWinners;
        uint256 ticketsSold;
        bool manuallyClosed;
        address token;
        address[] winners;
        mapping(uint256 => address) ticketMapping;
    }

    mapping(uint256 => Lottery) public lotteries;
    mapping(uint256 => Lottery) public requestIdToLotteryMapping;
    mapping(uint256 => mapping(address => bool)) public claimed;
    // lottery -> ticketid -> address
    mapping(uint256 => mapping(uint256 => address)) public ticketToAddressMapping;
  
    // 100 == 1%
    uint32 public callbackGasLimit = 50000;
    uint64 private subscriptionId;
    bytes32 private gasLaneKeyHash;
    uint256 public feePercentage = 500;
    uint256 public lotteryCount = 0;

    event LotteryCreated(
        uint256 id,
        uint256 startTime,
        uint256 endTime,
        uint256 ticketPrice,
        uint256 numberOfWinners,
        address token
    );
    event TicketBought(uint256 id, address buyer, uint256 amount);
    event PrizeClaimed(uint256 id, address claimer, uint256 amount);

    bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");

    constructor(address _coordinator, uint64 _subscriptionId, bytes32 _gasLaneKeyHash) VRFConsumerBaseV2(_coordinator, _link) {
        coordinator = VRFCoordinatorV2Interface(_coordinator);

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(WITHDRAW_ROLE, msg.sender);

        subscriptionId = _subscriptionId;
        gasLaneKeyHash = _gasLaneKeyHash;
    }

    function createLottery(uint256 _startTime, uint256 _endTime, uint256 _ticketPrice, uint256 _maxTickets, uint256 numberOfWinners, address _token) external returns(uint256 lotteryCount) { 
        if (_startTime < block.timestamp) {
            revert InvalidStartTime(_startTime);
        }
        if (_endTime < _startTime) {
            revert InvalidEndTime(_endTime);
        }
        if (_ticketPrice == 0) {
            revert InvalidTicketPrice(_ticketPrice);
        }
        if (_token == address(0)) {
            revert InvalidTokenAddress(_token);
        }
        ++lotteryCount
        lotteries[lotteryCount] = Lottery(lotteryCount, _startTime, _endTime, _ticketPrice, _maxTickets, numberOfWinners, 0, false, _token, new address[](0), new uint256[](0));
        emit LotteryCreated(lotteryCount, _startTime, _endTime, _ticketPrice, _maxTickets, numberOfWinners, _token);
    }

    function buyTickets(uint256 _id, uint256 _amount) external {
        Lottery memory lottery = lotteries[_id];
        if (lottery.id == 0) {
            revert InvalidLotteryId(_id);
        }
        if (lottery.startTime > block.timestamp) {
            revert LotteryHasNotStarted(_id);
        }
        if (lottery.endTime < block.timestamp) {
            revert LotteryHasAlreadyEnded(_id);
        }
        IERC20 token = IERC20(lotteries[_id].token);
        uint256 totalCost = lotteries[_id].ticketPrice * _amount;
        token.safeTransferFrom(msg.sender, address(this), totalCost);

        lotteries[_id].ticketsSold += _amount;

        for (uint256 i = 0; i < _amount; i++) {
            ticketToAddressMapping[_id][lotteries[_id].ticketsSold - i] = msg.sender;
        }

        emit TicketBought(_id, msg.sender, _amount);
    }

    function claimPrize(uint256 _id) external {
        Lottery memory lottery = lotteries[_id];
        if (lottery.id == 0) {
            revert InvalidLotteryId(_id);
        }
        if (lottery.manuallyClosed == false) {
            if (lottery.endTime > block.timestamp) {
                revert LotteryHasNotStarted(_id);
            }
        }
        if (claimed[_id][msg.sender] == true) {
            revert AlreadyClaimed(_id, msg.sender);
        }
        bool winner = false
        for (uint256 i = 0; i < lottery.winners.length; ++i) {
            if (lottery.winners[i] == msg.sender) {
              winner = true
            }
        }
        if (winner == false) {
            revert NotElligibleToClaim(_id, msg.sender);
        }

        IERC20 token = IERC20(lotteries[_id].token);
        uint256 prize = (lottery.ticketPrice * lottery.ticketsSold / lottery.numberOfWinners;
        token.safeTransfer(msg.sender, prize);
        claimed[_id][msg.sender] = true;
        emit PrizeClaimed(_id, msg.sender, prize);
    }
    
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        Lottery storage lottery = requestIdToLotteryMapping[_requestId];
        uint256 numberOfWinners = lottery.numberOfWinners;
        uint256 totalPrize = lottery.ticketPrice * lottery.ticketsSold;
        uint256 fee = (totalPrize * feePercentage) / 10000;

        for (uint256 i = 0; i < numberOfWinners; ++i) {
            uint256 winningTicket = _randomWords[i] % lottery.ticketsSold;
            lottery.winningTickets.push(winningTicket);
            // set the winning addresses correspoding to the tickets.
            lottery.winners.push(ticketToAddressMapping[lottery.id][winningTicket]);
        }
    }

    function checkUpkeep(bytes calldata checkData) external view override returns (bool upkeepNeeded, bytes memory performData) {
        // check for finished lotteries.
        for (uint256 i = 0; i < lotteries.length; ++i) {
            Lotery memory lottery = lotteries[i];
            if (lottery.endTime < block.timestamp || lottery.manuallyClosed == true) {
                upkeepNeeded = true;
                perfomData = checkData;
            }
        }
    }

    function performUpkeep(bytes calldata performData) external override {
        for (uint256 i = 0; i < lotteries.length; ++i) {
            storage loterry = lotteries[i];
            if ((lottery.endTime < block.timestamp || lottery.manuallyClosed) && lottery.winners.length == 0) {
                if (lottery.ticketsSold <= lottery.numberOfWinners) {
                    lottery.numberOfWinners = lottery.ticketsSold;
                }
                bytes32 requestId = coordinator.requestRandomWords(gasLaneKeyHash, subscriptionId, requestConfirmations, callbackGasLimit, lottery.numberOfWinners)
                requestIdToLotteryMapping[requestId] = lottery;
            }
        }
    }

    function closeLottery(uint256 _id) external onlyRole(DEFAULT_ADMIN_ROLE) {
        Lottery storage lottery = lotteries[_id];
        if (lottery.id == 0) {
            revert InvalidLotteryId(_id);
        }
        if (lottery.manuallyClosed == true) {
            revert LotteryAlreadyClosed(_id);
        } 
        if (lottery.endTime < block.timestamp) {
            revert LotteryHasAlreadyEnded(_id);
        }
        lottery.manuallyClosed = true;
    }

    function setRequestConfirmations(uint16 _requestConfirmations) external onlyRole(DEFAULT_ADMIN_ROLE) {
        requestConfirmations = _requestConfirmations;
    }

    function setCallbackGasLimit(uint32 _callbackGasLimit) external onlyRole(DEFAULT_ADMIN_ROLE) {
        callbackGasLimit = _callbackGasLimit;
    }

    function setGasLaneKeyHash(bytes32 _gasLaneKeyHash) external onlyRole(DEFAULT_ADMIN_ROLE) {
        gasLaneKeyHash = _gasLaneKeyHash;
    }

    function setSubscriptionId(uint16 _subscriptionId) external onlyRole(DEFAULT_ADMIN_ROLE) {
        subscriptionId = _subscriptionId;
    }

    function setFeePercentage(uint16 _feePercentage) public onlyRole(DEFAULT_ADMIN_ROLE) {
        if (_feePercentage > 10000) {
            revert InvalidFeePercentage({feePercentage : _feePercentage});
        }
        feePercentage = _feePercentage;
    }

    function withdrawFunds(address _token, address _to, uint256 _amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        IERC20 token = IERC20(_token);
        token.safeTransfer(_to, _amount);
    }
}
