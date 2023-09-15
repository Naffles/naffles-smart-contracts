// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import '@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol';
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBaseInternal.sol";

contract L2OpenEntryTicketDiamond is SolidStateDiamond, AccessControl, IL2OpenEntryTicketBaseInternal {
    constructor(address _admin) SolidStateDiamond() {
        _grantRole(AccessControlStorage.DEFAULT_ADMIN_ROLE, _admin);
        ERC721MetadataStorage.Layout storage metadata = ERC721MetadataStorage.layout();
        metadata.name = "OPENTICKET";
        metadata.symbol = "OPENTICKET";
    }
}