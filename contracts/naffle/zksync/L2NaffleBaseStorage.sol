// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../libraries/NaffleTypes.sol";

/**
    @dev diamond storage management for L2Naffle* contracts
 */
library L2NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.zksync.L2NaffleBaseStorage");

    /**
      @dev all storage variables for L2 Naffle contracts
     */
    struct Layout {
        address l1NaffleContractAddress;
        address l1MessengerContractAddress;
        address paidTicketContractAddress;
        address openEntryTicketContractAddress;
        // 100 = 1%
        uint256 openEntryTicketRatio;
        uint256 platformFee;
        uint256 maxPostponeTime;
        uint256 paidToOpenEntryRedeemRatio;
        mapping(uint256 => NaffleTypes.L2Naffle) naffles;
        uint256 platformFeesAccumulated;
        mapping(uint256 => bool) naffleRandomNumberRequested;
        address signatureSigner;
        bytes32 domainSignature;
        string domainName;
        bytes32 exchangeRateSignatureHash;
    }

    /**
      @dev Returns the storage struct from the specified slot
     */
    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}
