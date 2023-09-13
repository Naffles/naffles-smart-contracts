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
     * @notice mints OE tickets when redeeming used paid tickets
     * @dev method is called from the L2Naffle contract.
     * @param _to the address to mint the tickets to.
     * @param _amount the amount of tickets to mint.
     */
    function mintUponRedeemingPaidTickets(address _to, uint256 _amount) external; 
}
