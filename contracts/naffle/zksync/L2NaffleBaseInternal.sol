// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./L2NaffleBaseStorage.sol";
import "../../libraries/NaffleTypes.sol";
import '@solidstate/contracts/interfaces/IERC165.sol';
import '@solidstate/contracts/interfaces/IERC721.sol';
import '@solidstate/contracts/interfaces/IERC1155.sol';

import "@zksync/contracts/l1/zksync/interfaces/IZkSync.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleBaseInternal.sol";

abstract contract L2NaffleBaseInternal is IL2NaffleBaseInternal, AccessControlInternal {
    function _createNaffle(
        NaffleTypes.CreateZkSyncNaffleParams _params
    ) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();

        uint256 freeTicketSpots = 0;
        if (_params.naffleType == NaffleTypes.NaffleType.STANDARD) {
            freeTicketSpots = _params.paidTicketSpots / layout.freeTicketRatio;
        }
        layout.naffles[] = NaffleTypes.Naffle({
            ethTokenAddress: _params.ethTokenAddress,
            owner: _params.owner,
            naffleId: _params.naffleId,
            nftId: _params.nftId,
            paidTicketSpots: _params.paidTicketSpots,
            freeTicketSpots: freeTicketSpots,
            numberOfPaidTickets: 0,
            numberOfFreeTickets: 0,
            ticketPriceInWei: _params.ticketPriceInWei,
            endTime: _params.endTime,
            winningTicketId: 0,
            winningTicketType: NaffleTypes.TicketType.NONE,
            naffleTokenType: _naffleTokenType,
            status: NaffleTypes.NaffleStatus.ACTIVE,
            naffleType: _params.naffleType
        });
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }
}
