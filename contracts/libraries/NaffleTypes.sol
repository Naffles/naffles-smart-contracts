// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

library NaffleTypes {
    struct CreateZkSyncNaffleParams {
        address ethTokenAddress;
        address owner;
        uint256 naffleId;
        uint256 nftId;
        uint256 paidTicketSpots;
        uint256 ticketPriceInWei;
        uint256 endTime;
        NaffleType naffleType;
        TokenContractType naffleTokenType;
    }

    enum NaffleStatus {
        ACTIVE,
        POSTPONED,
        CANCELLED,
        SELECTING_WINNER,
        FINISHED
    }

    enum NaffleType {
        STANDARD,
        UNLIMITED
    }

    enum TicketType {
        NONE,
        FREE,
        PAID
    }

    enum TokenContractType {
        ERC721,
        ERC1155
    }

    struct L1Naffle {
        address tokenAddress;
        uint256 nftId;
        uint256 naffleId;
        address owner;
        address winner;
        bool winnerClaimed;
        bool cancelled;
        TokenContractType naffleTokenType;
    }

    struct OpenEntryTicket {
        uint256 naffleId;
        uint256 ticketIdOnNaffle;
        bool winningTicket;
    }

    struct PaidTicket {
        uint256 ticketPriceInWei;
        uint256 naffleId;
        uint256 ticketIdOnNaffle;
        bool winningTicket;
    }

    struct L2Naffle {
        address ethTokenAddress;
        address owner;
        uint256 naffleId;
        uint256 nftId;
        uint256 paidTicketSpots;
        uint256 freeTicketSpots;
        uint256 numberOfPaidTickets;
        uint256 numberOfOpenEntries;
        uint256 ticketPriceInWei;
        uint256 endTime;
        uint256 winningTicketId;
        TicketType winningTicketType;
        NaffleStatus status;
        TokenContractType naffleTokenType;
        NaffleType naffleType;
    }
}

