// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface INaffleVRF {
    /**
     * @notice requests a random nummber to be drawn for a specific naffle.
     * @param naffleId id of the naffle.
     */
    function drawWinner(uint256 naffleId) external;
}
