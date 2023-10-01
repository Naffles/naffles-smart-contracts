// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "../../libraries/NaffleTypes.sol";

/**
    @dev diamond storage management for L2Naffle* contracts
 */

library L2NaffleBaseStorage {
    bytes32 internal constant STORAGE_SLOT =
        keccak256("naffles.contracts.naffle.zksync.L2NaffleBaseStorage");

    ///@dev all storage variables for L2 Naffle contracts
    struct Layout {
        address l1NaffleContractAddress;
        address l1MessengerContractAddress;
        address l1StakingContractAddress;
        address paidTicketContractAddress;
        address openEntryTicketContractAddress;
        // 100 = 1%
        uint256 openEntryTicketRatio;
        uint256 platformFee;
        uint256 maxPostponeTime;
        // must be greater than 105 with current architecture and multipliers such as 1.25x for this number
        uint256 paidToOpenEntryBurnAmount;
        // second component of ratio i.e. can be 105:1, 105:2, 105:3, etc.
        uint256 paidToOpenEntryRedeemAmount;
        // defined in terms of 10000, so 1.25x --> 12500 - in contract, this results in something like (105 * 10000)/12500 = 84
        uint256[] stakingMultipliersForOETicketRedeem;
        mapping(uint256 => NaffleTypes.L2Naffle) naffles;
        uint256 platformFeesAccumulated;
        mapping(uint256 => bool) naffleRandomNumberRequested;
        mapping(address => uint256) userToStakedFoundersKeyAmount;
        mapping(address => mapping(uint256 => uint256)) userToStakedFoundersKeyIdsToStakeDuration;
    }

    ///@dev Returns the storage struct from the specified slot
    function layout() internal pure returns (Layout storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

