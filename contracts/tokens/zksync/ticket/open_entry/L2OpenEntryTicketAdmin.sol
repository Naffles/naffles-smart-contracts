// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2OpenEntryTicketBaseInternal.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/access/ownable/SafeOwnable.sol";
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketAdmin.sol";

contract L2OpenEntryTicketAdmin is IL2OpenEntryTicketAdmin, L2OpenEntryTicketBaseInternal, AccessControl, SafeOwnable {
    function setAdmin(address _admin) external onlyOwner {
        _grantRole(_getAdminRole(), _admin);
    }

    function adminMint(address _to, uint256 _amount) external onlyRole(_getAdminRole()){
        _adminMint(_to, _amount);
    }

    function setL2NaffleContractAddress(address _l2NaffleContractAddress) external onlyRole(_getAdminRole()) {
        _setL2NaffleContractAddress(_l2NaffleContractAddress);
    }

    function setBaseURI(string memory _baseURI) external onlyRole(_getAdminRole()) {
        _setBaseURI(_baseURI);
    }
}