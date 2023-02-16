// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IPaidTicketBase } from "../../../../../interfaces/tokens/zksync/tickets/paid/base/IPaidTicketBase.sol";

library NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256(
            "naffles.contract.tokens.zksync.tickets.paid.PaidTicketBaseStorage"
        );

    bytes32 internal constant NAFFLE_PLATFORM_ROLE = keccak256("NAFFLE_PLATFORM_ROLE");

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
        TicketType winningTicketType;
        NaffleStatus status;
        NaffleType naffleType;
    }

    struct Layout {
        IPaidTicketBase paidTicketContract;
        // 100 = 1%
        uint256 platformFee;
        // 100 = 1%
        uint256 freeTicketRatio;
        uint256 numberOfNaffles;
        uint256 minimumNaffleDuration;
        uint256 minimumPaidTicketSpots;
        uint256 platformFeeBalance;
        mapping(uint256 => Naffle) naffles;
}

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
