// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseInternal.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleAdmin.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/access/ownable/SafeOwnable.sol";

contract L2NaffleAdmin is IL2NaffleAdmin, L2NaffleBaseInternal, AccessControl, SafeOwnable {
    function setAdmin(address _admin) external onlyOwner {
        _grantRole(_getAdminRole(), _admin);
    }

    function setPlatformFee(uint256 _platformFee) external onlyRole(_getAdminRole()) {
        _setPlatformFee(_platformFee);
    }

    function setOpenEntryRatio(uint256 _freeTicketRatio) external onlyRole(_getAdminRole()) {
        _setOpenEntryRatio(_freeTicketRatio);
    }

    function setL1NaffleContractAddress(address _l1NaffleContractAddress) external onlyRole(_getAdminRole()) {
        _setL1NaffleContractAddress(_l1NaffleContractAddress);
    }

    function setPaidTicketContractAddress(address _paidTicketContractAddress) external onlyRole(_getAdminRole()) {
        _setPaidTicketContractAddress(_paidTicketContractAddress);
    }

    function setOpenEntryTicketContractAddress(address _openEntryTicketContractAddress) external onlyRole(_getAdminRole()) {
        _setOpenEntryTicketContractAddress(_openEntryTicketContractAddress);
    }

    function adminCancelNaffle(uint256 _naffleId) external onlyRole(_getAdminRole()) {
        _adminCancelNaffle(_naffleId);
    }
}