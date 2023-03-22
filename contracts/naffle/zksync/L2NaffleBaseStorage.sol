// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../libraries/NaffleTypes.sol";
import "@zksync/contracts/l2/system-contracts/interfaces/IL1Messenger.sol";


library L2NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.zksync.L2NaffleBaseStorage");

    uint160 constant SYSTEM_CONTRACTS_OFFSET = 0x8000;
    IL1Messenger constant L1_MESSENGER_CONTRACT = IL1Messenger(address(SYSTEM_CONTRACTS_OFFSET + 0x08));

    struct Layout {
        address l1NaffleContractAddress;
        address paidTicketContractAddress;
        address openEntryTicketContractAddress;
        // 100 = 1%
        uint256 freeTicketRatio;
        uint256 platformFee;
        mapping(uint256 => NaffleTypes.L2Naffle) naffles;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

