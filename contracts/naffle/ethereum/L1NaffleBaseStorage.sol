// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../libraries/NaffleTypes.sol";
import "@zksync/contracts/l2/system-contracts/interfaces/IL1Messenger.sol";

library L1NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.ethereum.L1NaffleBaseStorage");

    uint160 constant SYSTEM_CONTRACTS_OFFSET = 0x8000;
    IL1Messenger constant L1_MESSENGER_CONTRACT = IL1Messenger(address(SYSTEM_CONTRACTS_OFFSET + 0x08));

    struct Layout {
        address zkSyncAddress;
        address zkSyncNaffleContractAddress;
        address foundersKeyAddress;
        address foundersKeyPlaceholderAddress;
        uint256 numberOfNaffles;
        uint256 minimumNaffleDuration;
        uint256 minimumPaidTicketSpots;
        uint256 minimumPaidTicketPriceInWei;
        mapping(uint256 => NaffleTypes.L1Naffle) naffles;
        mapping(uint256 => address) naffleWinner;
        mapping(uint256 => mapping(uint256 => bool)) isL2ToL1MessageProcessed;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

