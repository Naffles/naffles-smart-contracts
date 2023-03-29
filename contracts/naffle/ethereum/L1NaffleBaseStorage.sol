// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../libraries/NaffleTypes.sol";
import "@zksync/contracts/l2/system-contracts/interfaces/IL1Messenger.sol";

library L1NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.ethereum.L1NaffleBaseStorage");

    address constant L1_MESSENGER_ADDRESS = address(0x79B2f0CbED2a565C925A8b35f2B402710564F8a2);

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

        // RequestId -> ChainlinkRequestStatus
        mapping(uint256 => NaffleTypes.ChainlinkRequestStatus) chainlinkRequestStatus;
        mapping(uint256 => uint256) naffleIdToChainlinkRequestId;

        bytes32 chainlinkVRFGasLaneKeyHash;
        uint64 chainlinkVRFSubscriptionId;
        uint32 chainlinkVRFCallbackGasLimit;
        uint16 chainlinkVRFRequestConfirmations;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

