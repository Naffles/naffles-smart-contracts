// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

interface IL2OpenEntryTicketBase {
    function adminMint(address _to, uint256 _amount) external;
    function attachToNaffle(uint256 _naffleId, uint256[] memory _ticketIds, uint256 startingTicketId, address owner) external;
    function getOpenEntryTicketById(uint256 _ticketId) external view returns (NaffleTypes.OpenEntryTicket memory);
}
