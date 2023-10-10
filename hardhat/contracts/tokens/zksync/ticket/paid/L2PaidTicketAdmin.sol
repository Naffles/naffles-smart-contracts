// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketBaseInternal.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/access/ownable/SafeOwnable.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketAdmin.sol";
import "@solidstate/contracts/token/ERC1155/metadata/ERC1155MetadataInternal.sol";

contract L2PaidTicketAdmin is IL2PaidTicketAdmin, L2PaidTicketBaseInternal, AccessControl, SafeOwnable, ERC1155MetadataInternal {
    /**
     * @inheritdoc IL2PaidTicketAdmin
     */
    function setAdmin(address _admin) external onlyOwner {
        _grantRole(_getAdminRole(), _admin);
    }

    /**
     * @inheritdoc IL2PaidTicketAdmin
     */
    function setL2NaffleContractAddress(address _l2NaffleContractAddress) external onlyRole(_getAdminRole()) {
        _setL2NaffleContractAddress(_l2NaffleContractAddress);
    }

    function setBaseURI(string memory _baseURI) external onlyRole(_getAdminRole()) {
        _setBaseURI(_baseURI);
    }
}
