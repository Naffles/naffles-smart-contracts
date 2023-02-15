// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { PaidTicketBaseStorage } from "./PaidTicketBaseStorage.sol";
import { AccessControlStorage } from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import { OwnableStorage } from "@solidstate/contracts/access/ownable/OwnableStorage.sol";
import { INaffleBase } from "../../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";
import { ERC721BaseInternal } from '@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol';
import { ERC721EnumerableInternal } from '@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol';

abstract contract PaidTicketBaseInternal is ERC721BaseInternal, ERC721EnumerableInternal {
    function _setNaffleContract(address _naffleContract) internal {
        PaidTicketBaseStorage.layout().naffleContract = INaffleBase(_naffleContract);
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getNaffleContractRole() internal pure returns (bytes32) {
        return PaidTicketBaseStorage.NAFFLE_CONTRACT_ROLE;
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
            _safeMint(_to, _totalSupply() + 1);
            l.paidTickets[_totalSupply()] = paidTicket;
            ticketIds[i] = _totalSupply();
        }
    }
}
