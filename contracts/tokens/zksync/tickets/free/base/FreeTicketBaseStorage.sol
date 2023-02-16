// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {INaffleBase} from "../../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";

library FreeTicketBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256(
            "naffles.contract.tokens.zksync.tickets.free.FreeTicketBaseStorage"
        );

    struct FreeTicket {
        address owner;
        uint256 naffleId;
        uint256 ticketIdOnNaffle;
        bool winningTicket;
    }

    bytes32 internal constant NAFFLE_CONTRACT_ROLE =
        keccak256("NAFFLE_CONTRACT_ROLE");

    struct Layout {
        INaffleBase naffleContract;
        // naffleId => ticketIdOnNaffle => FreeTicket
        mapping(uint256 => mapping(uint256 => FreeTicket)) freeTickets;
        mapping(uint256 => uint256) ticketIdNaffleTicketId;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
