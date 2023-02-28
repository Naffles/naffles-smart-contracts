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

    function setFreeTicketRatio(uint256 _freeTicketRatio) external onlyRole(_getAdminRole()) {
        _setFreeTicketRatio(_freeTicketRatio);
    }
}