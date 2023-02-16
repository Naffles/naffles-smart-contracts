// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IPaidTicketBase } from "../../../../../interfaces/tokens/zksync/tickets/paid/base/IPaidTicketBase.sol";
import { IFrreeTicketBase } from "../../../../../interfaces/tokens/zksync/tickets/free/base/IFreeTicketBase.sol";
import { NaffleTypes } from "../../../../libraries/NaffleTypes.sol";

library NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256(
            "naffles.contract.tokens.zksync.tickets.paid.NaffleBaseStorage"
        );

    bytes32 internal constant NAFFLE_PLATFORM_ROLE = keccak256("NAFFLE_PLATFORM_ROLE");

    struct Layout {
        IPaidTicketBase paidTicketContract;
        IFreeTicketBase freeTicketContract;
        // 100 = 1%
        uint256 platformFee;
        // 100 = 1%
        uint256 freeTicketRatio;
        uint256 numberOfNaffles;
        uint256 minimumNaffleDuration;
        uint256 minimumPaidTicketSpots;
        uint256 platformFeeBalance;
        mapping(uint256 => NaffleTypes.Naffle) naffles;
}

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
