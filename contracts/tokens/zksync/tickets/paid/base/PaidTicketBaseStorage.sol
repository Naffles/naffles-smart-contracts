// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {INaffleBase} from "../../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";

library PaidTicketBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256(
            "naffles.contract.tokens.zksync.tickets.paid.PaidTicketBaseStorage"
        );

    struct PaidTicket {
        address owner;
        uint256 ticketPriceInWei;
        uint256 naffleId;
        bool winningTicket;
    }

    bytes32 internal constant NAFFLE_CONTRACT_ROLE =
        keccak256("NAFFLE_CONTRACT_ROLE");

    struct Layout {
        INaffleBase naffleContract;
        mapping(uint256 => PaidTicket) paidTickets;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
