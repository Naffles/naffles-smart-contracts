//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "openzeppelin/token/ERC20/IERC20.sol";
import "openzeppelin/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/access/Ownable.sol";
import "./NafflesToken.sol";
import "forge-std/Test.sol";

contract NafflesStakingManager is Ownable{
    using SafeERC20 for IERC20; // Wrappers around ERC20 operations that throw on failure

    NafflesToken public rewardToken; // Token to be payed as reward

    uint256 private rewardTokensPerBlock; // Number of reward tokens minted per block
    uint256 private constant REWARDS_PRECISION = 1e12; // A big number to perform mul and div operations

    // Staking user for a pool
    struct PoolStaker {
        uint256 amount; // The tokens quantity the user has staked.
        uint256 rewards; // The reward tokens quantity the user can harvest
        uint256 rewardDebt; // The amount relative to accumulatedRewardsPerShare the user can't get as reward
    }

    // Staking pool
    struct Pool {
        IERC20 stakeToken; // Token to be staked
        uint256 tokensStaked; // Total tokens staked
        uint256 lastRewardedBlock; // Last block number the user had their rewards calculated
        uint256 accumulatedRewardsPerShare; // Accumulated rewards per share times REWARDS_PRECISION
        uint256 startTime; // Pool start time
        uint256 duration; // Pool duration
        uint256 poolRate; // Pool rate
    }

    Pool[] public pools; // Staking pools

    // Mapping poolId => staker address => PoolStaker
    mapping(uint256 => mapping(address => PoolStaker)) public poolStakers;

    // Events
    event Deposit(address indexed user, uint256 indexed poolId, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed poolId, uint256 amount);
    event HarvestRewards(address indexed user, uint256 indexed poolId, uint256 amount);
    event PoolCreated(uint256 poolId);

    // Constructor
    constructor(address _rewardTokenAddress, uint256 _rewardTokensPerBlock) {
        rewardToken = NafflesToken(_rewardTokenAddress);
        rewardTokensPerBlock = _rewardTokensPerBlock;
    }

    /**
     * @dev Create a new staking pool
     */
    function createPool(IERC20 _stakeToken, uint256 _poolRate, uint256 _startTime, uint256 _duration) external onlyOwner {
        Pool memory pool;
        pool.stakeToken =  _stakeToken;
        pool.poolRate = _poolRate;
        pool.startTime = _startTime;
        pool.duration = _duration;
        pool.lastRewardedBlock = block.timestamp;
        pools.push(pool);
        uint256 poolId = pools.length - 1;
        emit PoolCreated(poolId);
    }
    

    /**
     * @dev Deposit tokens to an existing pool
     */
    function deposit(uint256 _poolId, uint256 _amount) external {
        require(_amount > 0, "Deposit amount can't be zero");
        Pool storage pool = pools[_poolId];
        require(block.timestamp > pool.startTime && block.timestamp < pool.startTime + pool.duration, "pool not active");

        PoolStaker storage staker = poolStakers[_poolId][msg.sender];

        // Update current staker
        staker.amount = staker.amount + _amount;
        staker.rewardDebt = staker.amount * pool.accumulatedRewardsPerShare / REWARDS_PRECISION;

        // Update pool
        pool.tokensStaked = pool.tokensStaked + _amount;

        // Deposit tokens
        emit Deposit(msg.sender, _poolId, _amount);
        pool.stakeToken.safeTransferFrom(
            address(msg.sender),
            address(this),
            _amount
        );
    }

    /**
     * @dev Withdraw all tokens from an existing pool
     */
    function withdraw(uint256 _poolId) external {
        Pool storage pool = pools[_poolId];
        PoolStaker storage staker = poolStakers[_poolId][msg.sender];
        uint256 amount = staker.amount;
        require(amount > 0, "Withdraw amount can't be zero");

        // Pay rewards
        harvestRewards(_poolId);

        // Update staker
        staker.amount = 0;
        staker.rewardDebt = staker.amount * pool.accumulatedRewardsPerShare / REWARDS_PRECISION;

        // Update pool
        pool.tokensStaked = pool.tokensStaked - amount;

        // Withdraw tokens
        emit Withdraw(msg.sender, _poolId, amount);
        pool.stakeToken.safeTransfer(
            address(msg.sender),
            amount
        );
    }

    /**
     * 
     * @param _poolId pool ID of user deposited
     */
    function getPendingNaffles(uint256 _poolId, address _sender) external view returns (uint256) {
        Pool storage pool = pools[_poolId];
        PoolStaker storage staker = poolStakers[_poolId][_sender];
        uint256 blocksSinceLastReward;
        if(block.timestamp > pool.startTime + pool.duration){
            blocksSinceLastReward = pool.startTime + pool.duration - pool.lastRewardedBlock;
        }else{
            blocksSinceLastReward = block.timestamp - pool.lastRewardedBlock;
        }
        uint256 rewards = blocksSinceLastReward * rewardTokensPerBlock  * pool.poolRate;
        uint256 calcAccumulatedShare = pool.accumulatedRewardsPerShare + (rewards * REWARDS_PRECISION / pool.tokensStaked);
        uint256 rewardsToHarvest = (staker.amount * calcAccumulatedShare / REWARDS_PRECISION) - staker.rewardDebt;
        
        return rewardsToHarvest;
    }

    /**
     * @dev Harvest user rewards from a given pool id
     */
    function harvestRewards(uint256 _poolId) public {
        updatePoolRewards(_poolId);
        Pool storage pool = pools[_poolId];
        PoolStaker storage staker = poolStakers[_poolId][msg.sender];
        uint256 rewardsToHarvest = (staker.amount * pool.accumulatedRewardsPerShare / REWARDS_PRECISION) - staker.rewardDebt;
        if (rewardsToHarvest == 0) {
            staker.rewardDebt = staker.amount * pool.accumulatedRewardsPerShare / REWARDS_PRECISION;
            return;
        }
        staker.rewards = 0;
        staker.rewardDebt = staker.amount * pool.accumulatedRewardsPerShare / REWARDS_PRECISION;
        emit HarvestRewards(msg.sender, _poolId, rewardsToHarvest);
        rewardToken.mint(msg.sender, rewardsToHarvest);
    }

    /**
     * @dev Update pool's accumulatedRewardsPerShare and lastRewardedBlock
     */
    function updatePoolRewards(uint256 _poolId) private {
        Pool storage pool = pools[_poolId];
        if (pool.tokensStaked == 0) {
            pool.lastRewardedBlock = block.timestamp;
            return;
        }
        uint256 blocksSinceLastReward;
        if(block.timestamp > pool.startTime + pool.duration){
            blocksSinceLastReward = pool.startTime + pool.duration - pool.lastRewardedBlock;
            pool.lastRewardedBlock = pool.startTime + pool.duration;
        }else{
            blocksSinceLastReward = block.timestamp - pool.lastRewardedBlock;
            pool.lastRewardedBlock = block.timestamp;
        }
        uint256 rewards = blocksSinceLastReward * rewardTokensPerBlock * pool.poolRate;
        pool.accumulatedRewardsPerShare = pool.accumulatedRewardsPerShare + (rewards * REWARDS_PRECISION / pool.tokensStaked);
    }
}