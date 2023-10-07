// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import '@solidstate/contracts/token/ERC1155/metadata/ERC1155MetadataStorage.sol';
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBaseInternal.sol";

contract L2PaidTicketDiamond is SolidStateDiamond, AccessControl, IL2PaidTicketBaseInternal {
    constructor(address _admin) SolidStateDiamond() {
        _grantRole(AccessControlStorage.DEFAULT_ADMIN_ROLE, _admin);
        ERC1155MetadataStorage.Layout storage metadata = ERC1155MetadataStorage.layout();
        metadata.name = "TICKET";
        metadata.symbol = "TICKET";
    }
}