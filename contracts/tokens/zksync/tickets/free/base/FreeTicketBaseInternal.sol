// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {FreeTicketBaseStorage} from "./FreeTicketBaseStorage.sol";
import {AccessControlStorage} from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import {OwnableStorage} from "@solidstate/contracts/access/ownable/OwnableStorage.sol";
import {INaffleBase} from "../../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";
import {ERC721BaseInternal} from "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import {ERC721EnumerableInternal} from "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";

error InvalidNaffleId(uint256 naffleId);

abstract contract FreeTicketBaseInternal is
    ERC721BaseInternal,
    ERC721EnumerableInternal
{
    function _setNaffleContract(address _naffleContract) internal {
        FreeTicketBaseStorage.layout().naffleContract = INaffleBase(
            _naffleContract
        );
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getNaffleContractRole() internal pure returns (bytes32) {
        return FreeTicketBaseStorage.NAFFLE_CONTRACT_ROLE;
    }

    function _mintTickets(
        address _to,
        uint256 _amount,
        uint256 _naffleId
    ) internal returns (uint256[] memory ticketIds) {
        ticketIds = new uint256[](_amount);
        FreeTicketBaseStorage.Layout storage l = FreeTicketBaseStorage.layout();
        NaffleBaseStorage.Naffle memory naffle = l.naffleContract.getNaffleInfo(_naffleId);

        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }

        for (uint256 i = naffle.numberOfFreeTickets; i < _amount; ++i) {
            FreeTicketBaseStorage.FreeTicket
                memory freeTicket = FreeTicketBaseStorage.FreeTicket({
                    owner: _to,
                    naffleId: _naffleId,
                    ticketIdOfNaffle: i + 1,
                    winningTicket: false
                });
            _safeMint(_to, _totalSupply() + 1);
            l.ticketIdNaffleTicketId[_totalSupply()] = i + 1;
            l.paidTickets[_totalSupply()] = FreeTicket;
            ticketIds[i] = _totalSupply();
        }
    }

    function _setWinningTicket(uint256 _naffleId, uint256 _ticketId) internal {
        FreeTicketBaseStorage.Layout storage l = FreeTicketBaseStorage.layout();
        l.paidTickets[_ticketId].winningTicket = true;
    }
}
