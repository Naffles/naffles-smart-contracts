// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {INaffleBase} from "../../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";
import {NaffleTypes} from "../../../../../libraries/NaffleTypes.sol";

library PaidTicketBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256(
            "naffles.contracts.tokens.zksync.tickets.paid.PaidTicketBaseStorage"
        );

    bytes32 internal constant NAFFLE_CONTRACT_ROLE =
        keccak256("NAFFLE_CONTRACT_ROLE");

    struct Layout {
        INaffleBase naffleContract;
        // naffleId => ticketId => PaidTicket
        mapping(uint256 => mapping(uint256 => NaffleTypes.PaidTicket)) paidTickets;
        mapping(uint256 => uint256) ticketIdNaffleTicketId;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
