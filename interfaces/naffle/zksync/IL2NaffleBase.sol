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
     * @notice cancel a naffle.
     * @dev method can be called by the owner of a naffle.
     * @param _naffleId id of the naffle.
     */
    function ownerCancelNaffle(
        uint256 _naffleId
    ) external;

    /**
     * @notice end a naffle.
     * @param _naffleId id of the naffle.
     */
    function ownerDrawWinner(uint256 _naffleId) external returns (bytes32);
}
