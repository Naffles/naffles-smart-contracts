// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SolidStateERC721 } from "@solidstate/contracts/token/erc721/SolidStateERC721.sol";
import { PaidTicketBaseStorage } from "./PaidTicketBaseStorage.sol";
import { AccessControlStorage } from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import { OwnableStorage } from "@solidstate/contracts/access/ownable/OwnableStorage.sol";

abstract contract PaidTicketBaseInternal is SolidStateERC721, Ownable {
    function _setNaffleContract(address _naffleContract) internal {
        PaidTicketBaseStorage.layout().naffleContract = INaffle(_naffleContract);
    }

    function _getNaffleContract() internal view returns (address) {
        return PaidTicketBaseStorage.layout().naffleContract;
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256, _ticketPriceInWei) internal returns(uint256[] ticketIds){
        ticketIds = new uint256[](_amount);
        PaidTicketBaseStorage storage s = PaidTicketBaseStorage.layout();
        for (uint256 i = 0; i < _amount; i++) {
            PaidTicketBaseStorage.PaidTicket memory paidTicket = PaidTicketBaseStorage.PaidTicket({
                owner: _to,
                ticketPriceInWei: _ticketPriceInWei,
                naffleId: _naffleId,
                winningTicket: false
            });
            _safeMint(_to, totalSupply() + 1);
            s.paidTickets[totalSupply()] = paidTicket;
            ticketIds[i] = totalSupply();
        }
    }
}
