// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SolidStateERC721 } from "@solidstate/contracts/token/erc721/SolidStateERC721.sol";
import { Ownable } from "@solidstate/contracts/access/Ownable.sol";
import { PaidTicketBaseStorage } from "./PaidTicketBaseStorage.sol";
import { AccessControlStorage } from "@solidstate/contracts/access/acess_control/AccessControlStorage.sol";


contract PaidTicketBaseInternal is SolidStateERC721 {
    function _setNaffleContract(address _naffleContract) internal {
        PaidTicketBaseStorage.layout().naffleContract = _naffleContract;
    }

    function _getNaffleContract() internal view returns (address) {
        return PaidTicketBaseStorage.layout().naffleContract;
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }
}
