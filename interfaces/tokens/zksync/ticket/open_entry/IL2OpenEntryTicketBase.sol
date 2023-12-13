// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title interface for L2OpenEntryTicketBase
 */
interface IL2OpenEntryTicketBase {
    /**
     * @notice attach to naffle, assigns the tickets to the naffle.
     * @dev method is called from the naffle contract.
     * @param _naffleId id of the naffle.
     * @param _ticketIds ids of the tickets.
     * @param startingTicketId the starting ticket id on the naffle.
     * @param owner the owner of the tickets.
     */
    function attachToNaffle(uint256 _naffleId, uint256[] memory _ticketIds, uint256 startingTicketId, address owner) external;

    /**
     * @notice detach from naffle, removes the tickets from the naffle.
     * @dev method is called from the naffle contract.
     * @param _naffleId id of the naffle.
     * @param _naffleTicketIds ids of the tickets on the naffle.
     */
    function detachFromNaffle(uint256 _naffleId, uint256[] memory _naffleTicketIds) external;

    /**
     * @notice mint open entry tickets for user.
     * @dev method is called from the naffle contract.
     * @param _to address of the user.
     * @param _amount amount of tickets to mint.
     */
    function mintOpenEntryTicketsForUser(
        address _to,
        uint256 _amount
    ) external;

    /**
     * @notice mint open entry staking rewards
     * @dev method is called by the user with a signature validating the rewards
     * @param _amount amount of open entry tickets to validate
     * @param _totalClaimed total tickets claimed to fair, is used so signature is only valid 1 time
     * @params _signature the signature to validate the claim
     */
     function claimStakingReward(
        uint256 _amount,
        uint256 _totalClaimed
     ) external;
}
