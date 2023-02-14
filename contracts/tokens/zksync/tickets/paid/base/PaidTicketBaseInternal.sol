// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SolidStateERC721 } from "@solidstate/contracts/token/erc721/SolidStateERC721.sol";
import { PaidTicketBaseStorage } from "./PaidTicketBaseStorage.sol";
import { AccessControlStorage } from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import { OwnableStorage } from "@solidstate/contracts/access/ownable/OwnableStorage.sol";
import { INaffleBase } from "../../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";

abstract contract PaidTicketBaseInternal is SolidStateERC721 {
    function _setNaffleContract(address _naffleContract) internal {
        PaidTicketBaseStorage.layout().naffleContract = INaffleBase(_naffleContract);
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 _ticketPriceInWei) internal returns(uint256[] memory ticketIds){
        ticketIds = new uint256[](_amount);
        PaidTicketBaseStorage.Layout storage l = PaidTicketBaseStorage.layout();
        for (uint256 i = 0; i < _amount; i++) {
            PaidTicketBaseStorage.PaidTicket memory paidTicket = PaidTicketBaseStorage.PaidTicket({
                owner: _to,
                ticketPriceInWei: _ticketPriceInWei,
                naffleId: _naffleId,
                winningTicket: false
            });
            _safeMint(_to, totalSupply() + 1);
            l.paidTickets[totalSupply()] = paidTicket;
            ticketIds[i] = totalSupply();
        }
    }
}
