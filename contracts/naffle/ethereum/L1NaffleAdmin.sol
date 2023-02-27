// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./L1NaffleBaseInternal.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleAdmin.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/access/ownable/SafeOwnable.sol";

contract L1NaffleAdmin is IL1NaffleAdmin, L1NaffleBaseInternal, AccessControl, SafeOwnable {
    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external onlyRole(_getAdminRole()) {
        _setMinimumNaffleDuration(_minimumNaffleDuration);
    }

    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external onlyRole(_getAdminRole()) {
        _setMinimumPaidTicketSpots(_minimumPaidTicketSpots);
    }

    function setMinimumPaidTicketPrice(uint256 _minimumPaidTicketPrice) external onlyRole(_getAdminRole()) {
        _setMinimumPaidTicketPrice(_minimumPaidTicketPrice);
    }

    function setZkSyncNaffleContractAddress(address _zksyncNaffleContractAddress) external onlyRole(_getAdminRole()) {
        _setZkSyncNaffleContractAddress(_zksyncNaffleContractAddress);
    }

    function setZkSyncAddress(address _zksyncAddress) external onlyRole(_getAdminRole()) {
        _setZkSyncAddress(_zksyncAddress);
    }

    function setFoundersKeyAddress(address _foundersKeyAddress) external onlyRole(_getAdminRole()) {
        _setFoundersKeyAddress(_foundersKeyAddress);
    }

    function setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) external onlyRole(_getAdminRole()) {
        _setFoundersKeyPlaceholderAddress(_foundersKeyPlaceholderAddress);
    }

    function setAdmin(address _admin) external onlyOwner {
        _grantRole(_getAdminRole(), _admin);
    }
}