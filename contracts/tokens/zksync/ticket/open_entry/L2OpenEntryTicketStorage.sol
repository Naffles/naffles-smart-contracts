// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../libraries/NaffleTypes.sol";

library L2OpenEntryTicketStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.tokens.zksync.ticket.open_entry.L2OpenEntryTicketStorage");

    struct Layout {
        address l2NaffleContractAddress;
        // naffle id => ticket id on naffle => ticket
        mapping(uint256 => mapping(uint256 => NaffleTypes.OpenEntryTicket)) openEntryTickets;
        // ticket id => ticket id on naffle
        mapping(uint256 => uint256) ticketIdNaffleTicketId;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

