// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import '@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol';

contract L2PaidTicketDiamond is SolidStateDiamond, AccessControl {
    constructor(address _admin) SolidStateDiamond() {
        _grantRole(AccessControlStorage.DEFAULT_ADMIN_ROLE, _admin);
        ERC721MetadataStorage.Layout storage metadata = ERC721MetadataStorage.layout();
        metadata.name = "TICKET";
        metadata.symbol = "TICKET";
    }
}