// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

interface IL2NaffleBase {
    function createNaffle(
        NaffleTypes.CreateZkSyncNaffleParams memory _params
    ) external;
}