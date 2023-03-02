// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL2OpenEntryTicketBase {
    function adminMint(address _to, uint256 _amount) external;
    function attachToNaffle(uint256 _naffleId, uint256[] memory _ticketIds) external;
}
