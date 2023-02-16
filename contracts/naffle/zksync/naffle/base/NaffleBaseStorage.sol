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

    struct Naffle {
        address ethTokenAddress;
        uint256 nftId;
        uint256 paidTicketSpots;
        uint256 freeTicketSpots;
        uint256 numberOfPaidTickets;
        uint256 numberOfFreeTickets;
        uint256 ticketPriceInWei;
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
        mapping(uint256 => Naffle) naffles;
}

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
