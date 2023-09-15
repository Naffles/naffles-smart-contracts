// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "./L1NaffleBaseInternal.sol";

/**
    @title L1 Naffle Diamond
    @dev diamond implementation contract for L1 Naffle
    @notice inherits from SolidStateDiamond, AccessControl, L1NaffleBaseInternal
 */

contract L1NaffleDiamond is SolidStateDiamond, AccessControl, L1NaffleBaseInternal {
    constructor(
        address _admin,
        uint256 _minimumNaffleDuration,
        uint256 _minimumPaidTicketSpots,
        uint256 _minimumTicketPriceInWei,
        address _zksyncContractAddress,
        address _foundersKeyContractAddress,
        address _foundersKeyPlaceholderAddress
    ) SolidStateDiamond() {
        _grantRole(AccessControlStorage.DEFAULT_ADMIN_ROLE, _admin);
        _setMinimumNaffleDuration(_minimumNaffleDuration);
        _setMinimumPaidTicketSpots(_minimumPaidTicketSpots);
        _setMinimumPaidTicketPriceInWei(_minimumTicketPriceInWei);
        _setFoundersKeyAddress(_foundersKeyContractAddress);
        _setFoundersKeyPlaceholderAddress(_foundersKeyPlaceholderAddress);
        _setZkSyncAddress(_zksyncContractAddress);
    }
}