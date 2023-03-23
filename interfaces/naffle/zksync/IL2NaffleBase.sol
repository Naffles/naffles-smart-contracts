// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

interface IL2NaffleBase {
    function createNaffle(
        NaffleTypes.CreateZkSyncNaffleParams memory _params
    ) external;

    function buyTickets(
        uint256 _amount,
        uint256 _naffleId
    ) external payable returns (uint256[] memory ticketIds);

    function useOpenEntryTickets(
        uint256[] memory _ticketIds,
        uint256 _naffleId
    ) external;

    function claimRefund(uint256 _naffleId, uint256[] _open_entry_ticket_ids, uint256[] _paid_ticket_ids) external;
}
