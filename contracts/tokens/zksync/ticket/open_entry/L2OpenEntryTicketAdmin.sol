// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2OpenEntryTicketBaseInternal.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/access/ownable/SafeOwnable.sol";
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketAdmin.sol";

contract L2OpenEntryTicketAdmin is IL2OpenEntryTicketAdmin, L2OpenEntryTicketBaseInternal, AccessControl, SafeOwnable {
    /**
     * @inheritdoc IL2OpenEntryTicketAdmin
     */
    function setAdmin(address _admin) external onlyOwner {
        _grantRole(_getAdminRole(), _admin);
    }

    /**
     * @inheritdoc IL2OpenEntryTicketAdmin
     */
    function adminMint(address _to, uint256 _amount) external onlyRole(_getAdminRole()){
        _adminMint(_to, _amount);
    }

    /**
     * @inheritdoc IL2OpenEntryTicketAdmin
     */
    function setL2NaffleContractAddress(address _l2NaffleContractAddress) external onlyRole(_getAdminRole()) {
        _setL2NaffleContractAddress(_l2NaffleContractAddress);
    }

    function setBaseURI(string memory _baseURI) external onlyRole(_getAdminRole()) {
        _setBaseURI(_baseURI);
    }

    /**
     * @inheritdoc IL2OpenEntryTicketAdmin
     */
    function removeAdmin(address _admin) external onlyOwner {
        _revokeRole(_getAdminRole(), _admin);
    }
}