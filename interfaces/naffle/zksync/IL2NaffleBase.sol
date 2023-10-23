// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title interface for L2NaffleBase
 */
interface IL2NaffleBase {
    /**
     * @notice create a naffle.
     * @dev method is called by the zksync contract when a user creates a naffle on L1.
     * @param _params the params to create a naffle.
     */
    function createNaffle(
        NaffleTypes.CreateZkSyncNaffleParams memory _params
    ) external;

    /**
     * @notice buy tickets for a specific naffle.
     * @param _naffleId id of the naffle.
     * @return ticketIds ids of the tickets bought.
     */
    function buyTickets(
        uint256 _amount,
        uint256 _naffleId
    ) external payable returns (uint256[] memory ticketIds);

    /**
     * @notice use open entry tickets. Assigns the tickets to the naffle.
     * @param _ticketIds ids of the tickets.
     * @param _naffleId id of the naffle.
     */
    function useOpenEntryTickets(
        uint256[] memory _ticketIds,
        uint256 _naffleId
    ) external;

    /**
     * @notice refund and burns tickets for a naffle.
     * @param _naffleId id of the naffle.
     * @param _openEntryTicketIds ids of the open entry tickets.
     * @param _owner owner of the tickets.
     */
    function refundTicketsForNaffle(
        uint256 _naffleId,
        uint256[] memory _openEntryTicketIds,
        address _owner
    ) external;

    /**
     * @notice cancel a naffle.
     * @dev method can be called by the owner of a naffle.
     * @param _naffleId id of the naffle.
     */
    function ownerCancelNaffle(
        uint256 _naffleId
    ) external;

    /**
     * @notice get the winner of a naffle.
     * @param _naffleId id of the naffle.
     */
    function drawWinner(uint256 _naffleId) external;

    /**
     * @notice get the winner of a naffle. can be called before the naffle is sold out or ended.
     * @param _naffleId id of the naffle.
     */
    function ownerDrawWinner(uint256 _naffleId) external;

    /**
     * @notice postpone a naffle.
     * @param _naffleId id of the naffle.
     * @param _newEndTime new end time of the naffle.
     */
    function postponeNaffle(
        uint256 _naffleId,
        uint256 _newEndTime
    ) external;

    /**
     * @notice set the winner of a naffle.
     * @param _naffleId id of the naffle.
     * @param _randomNumber random number of the winner.
     * @param _winner winner of the naffle.
     * @param _platformDiscountInPercent platform discount in percent.
     * @return bytes32 hash of the winner.
     */
    function setWinner(
        uint256 _naffleId,
        uint256 _randomNumber,
        address _winner,
        uint256 _platformDiscountInPercent
    ) external returns (bytes32);
}
