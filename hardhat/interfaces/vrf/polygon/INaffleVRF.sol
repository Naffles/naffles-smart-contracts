// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface INaffleVRF {
    /**
     * @notice Draw a winner for a naffle
     * @param _naffleId The naffle to draw a winner for
     */
    function drawWinner(uint256 _naffleId) external;
}
