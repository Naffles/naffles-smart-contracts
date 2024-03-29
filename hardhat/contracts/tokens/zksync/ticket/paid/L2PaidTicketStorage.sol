// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../libraries/NaffleTypes.sol";


library L2PaidTicketStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.tokens.zksync.ticket.paid.L2PaidTicketStorage");

    struct Layout {
        address l2NaffleContractAddress;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

