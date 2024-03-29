// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../libraries/NaffleTypes.sol";
import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IL1Messenger.sol";


/**
 *  @dev diamond storage management for L1Naffle* contracts
 */
library L1NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.ethereum.L1NaffleBaseStorage");

    /**
     * @dev all storage variables for L1 Naffle contracts
     */
    struct Layout {
        address zkSyncAddress;
        address zkSyncNaffleContractAddress;
        address foundersKeyAddress;
        address foundersKeyPlaceholderAddress;
        uint256 numberOfNaffles;
        uint256 minimumNaffleDuration;
        uint256 minimumPaidTicketSpots;
        mapping(uint256 => NaffleTypes.L1Naffle) naffles;
        mapping(uint256 => mapping(uint256 => bool)) isL2ToL1MessageProcessed;
        address signatureSigner; 
        bytes32 collectionWhitelistSignature;
        bytes32 domainSignature;
        string domainName;
    }

    /**
     * @dev Returns the storage struct from the specified slot
     */
    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

