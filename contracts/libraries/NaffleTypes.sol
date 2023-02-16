// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library NaffleTypes {
    enum NaffleStatus {
        ACTIVE,
        POSTPONED,
        CLOSED,
        FINISHED
    }

    enum NaffleType {
        STANDARD,
        UNLIMITED
    }

    enum PostponeTime {
        ONE_DAY,
        TWO_DAYS,
        THREE_DAYS,
        FOUR_DAYS,
        FIVE_DAYS,
        SIX_DAYS,
        ONE_WEEK
    }

    enum TicketType {
        NONE,
        FREE,
        PAID
    }

    struct FreeTicket {
        address owner;
        uint256 naffleId;
        uint256 ticketIdOnNaffle;
        bool winningTicket;
    }

    struct PaidTicket {
        address owner;
        uint256 ticketPriceInWei;
        uint256 naffleId;
        uint256 ticketIdOnNaffle;
        bool winningTicket;
    }
    
    struct Naffle {
        address ethTokenAddress;
        address owner;
        uint256 nftId;
        uint256 paidTicketSpots;
        uint256 freeTicketSpots;
        uint256 numberOfPaidTickets;
        uint256 numberOfFreeTickets;
        uint256 ticketPriceInWei;
        uint256 endTime;
        uint256 winningTicketId;
        NaffleTypes.TicketType winningTicketType;
        NaffleTypes.NaffleStatus status;
        NaffleTypes.NaffleType naffleType;
    }
}



