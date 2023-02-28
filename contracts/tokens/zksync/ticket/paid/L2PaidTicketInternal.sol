// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketStorage.sol";

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBaseInternal.sol";

abstract contract L2PaidTicketBaseInternal is IL2PaidTicketBaseInternal, AccessControlInternal {
    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getL2NaffleContractAddress() internal view returns (address) {
        return L2PaidTicketStorage.layout().l2NaffleContractAddress;
    }

    function _setL2NaffleContractAddress(address _l2NaffleContractAddress) internal {
        L2PaidTicketStorage.layout().l2NaffleContractAddress = _l2NaffleContractAddress;
    }
}
