// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

interface IL1NaffleBase {
    function createNaffle(
        NaffleTypes.CreateNaffleParams memory _createNaffle
    ) external returns (uint256 naffleId, bytes32 txHash);

    error NotSupported();
}
