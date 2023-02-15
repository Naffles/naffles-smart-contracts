// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IPaidTicketBase} from "../../../../../interfaces/tokens/zksync/tickets/paid/base/IPaidTicketBase.sol";

library NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256(
            "naffles.contract.tokens.zksync.tickets.paid.PaidTicketBaseStorage"
        );

    enum NaffleStatus {
        ACTIVE,
        POSTPONED,
        CLOSED,
        FINISHED
    }

    struct Naffle {
        address ethTokenSddress;
        uint256 paidTicketSpots;
        uint256 freeTicketSpots;
        uint256 numberOfPaidTickets;
        uint256 numberOfFreeTickets;
        uint256 ticketPriceInWei;
        NaffleStatus status;
    }

    struct Layout {
        IPaidTicketBase paidTicketContract;
        mapping(uint256 => Naffle) naffles;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
