// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import '../../staking/FoundersKeyStaking.sol';

contract FoundersKeyStakingMock is FoundersKeyStaking {
    function test() external view returns (uint256) {
        return 1;
    }
}

