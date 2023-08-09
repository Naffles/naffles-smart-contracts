// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title Interface for L2 Naffle Base Internal
 */
interface IL2NaffleBaseInternal {
    /**
     * @notice thrown when the msg.sender is not allowed to call the function.
     */
    error NotAllowed();

    /**
     * @notice thrown when the naffle id is invalid.
     * @param naffleId the naffle id.
     */
    error InvalidNaffleId(uint256 naffleId);

    /**
     * @notice thrown when the naffle status is invalid.
     * @param status the naffle status.
     */
    error InvalidNaffleStatus(NaffleTypes.NaffleStatus status);

    /**
     * @notice thrown when not enough funds are sent to pay for the tickets.
     * @param amount funds sent to buy tickets.
     */
    error NotEnoughFunds(uint256 amount);

    /**
     * @notice thrown when not enough paid ticket spots are available on the naffle.
     * @param amount amount of tickets to buy.
     */
    error NotEnoughPaidTicketSpots(uint256 amount);

    /**
     * @notice thrown when not enough open entry ticket spots are available on the naffle.
     * @param amount amount of tickets to buy.
     */
    error NotEnoughOpenEntryTicketSpots(uint256 amount);

    /**
     * @notice thrown when the open entry ratio is zero.
     */
    error OpenTicketRatioCannotBeZero();

    /**
     * @notice thrown when the naffle has not ended yet.
     * @param endTime end time of the naffle.
     */
    error NaffleNotEndedYet(uint256 endTime);

    /**
     * @notice thrown when the naffle is sold out.
     */
    error NaffleSoldOut();

    /**
     * @notice thrown when the naffle type is invalid.
     * @param naffleType naffle type.
     */
    error InvalidNaffleType(NaffleTypes.NaffleType naffleType);

    /**
     * @notice thrown when there are no tickets to draw a winner from.
     */
    error NoTicketsBought();

    /**
     * @notice thrown when the withdraw of funds fails.
     */
    error UnableToSendFunds();

    /**
     * @notice thrown when there are not enough funds to withdraw.
     */
    error InsufficientFunds();

    /**
     * @notice thrown when the caller is not the naffle owner.
     * @param owner owner of the naffle.
     */
    error NotNaffleOwner(address owner);

    /**
     * @notice thrown when the entTime passed is invalid.
     * @param endTime end time of the naffle.
     */
    error InvalidEndTime(uint256 endTime);

    /**
     * @notice thrown when the naffle is not finished.
     * @param endTime end time of the naffle.
     */
    error NaffleNotFinished(uint256 endTime);

    /**
     * @notice emitted when a naffle is created.
     * @param naffleId id of the naffle.
     * @param owner address of the owner.
     * @param ethTokenAddress address of the ETH token.
     * @param nftId id of the NFT.
     * @param paidTicketSpots number of paid ticket spots.
     * @param openEntryTicketSpots number of free ticket spots.
     * @param ticketPriceInWei price of the ticket in wei.
     * @param endTime end time of the naffle.
     * @param naffleType type of the naffle.
     * @param tokenContractType type of the token contract.
     */
    event L2NaffleCreated(
        uint256 naffleId,
        address indexed owner,
        address indexed ethTokenAddress,
        uint256 nftId,
        uint256 paidTicketSpots,
        uint256 openEntryTicketSpots,
        uint256 ticketPriceInWei,
        uint256 endTime,
        NaffleTypes.NaffleType indexed naffleType,
        NaffleTypes.TokenContractType tokenContractType
    );

    /**
     * @notice emitted when a tickets are bought.
     * @param naffleId id of the naffle.
     * @param buyer address of the buyer.
     * @param ticketIds ids of the tickets bought.
     * @param ticketPriceInWei price of the ticket in wei.
     */
    event TicketsBought(
        uint256 indexed naffleId,
        address indexed buyer,
        uint256[] ticketIds,
        uint256 ticketPriceInWei
    );

    /**
     * @notice emitted when open entry tickets are used for a naffle.
     * @param naffleId id of the naffle.
     * @param owner address of the owner.
     * @param ticketIds ids of the tickets used.
     */
    event OpenEntryTicketsUsed(
        uint256 indexed naffleId,
        address indexed owner,
        uint256[] ticketIds
    );

    /**
     * @notice emitted when a naffle is cancelled.
     * @param naffleId id of the naffle.
     * @param messageHash hash of the transaction sent to the L1.
     */
    event L2NaffleCancelled(uint256 indexed naffleId, bytes32 messageHash);

    /**
     * @notice emitted when a naffle is finished and winner is drawn.
     * @param naffleId id of the naffle.
     * @param winner address of the winner.
     * @param winningTicketIdOnNaffle id of the winning ticket on the naffle.
     * @param messageHash hash of the transaction sent to the L1.
     */
    event L2NaffleFinished(uint256 indexed naffleId, address winner, uint256 winningTicketIdOnNaffle, bytes32 messageHash);

    /**
     * @notice emitted when a naffle is postponed.
     * @param naffleId id of the naffle.
     * @param newEndTime new end time of the naffle.
     */
    event L2NafflePostponed(uint256 indexed_naffleId, uint256 _newEndTime);
);
}
