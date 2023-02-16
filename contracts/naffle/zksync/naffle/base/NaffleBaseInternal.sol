// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {NaffleBaseStorage} from "./NaffleBaseStorage.sol";
import {AccessControlStorage} from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import {IPaidTicketBase} from "../../../../../interfaces/tokens/zksync/tickets/paid/base/IPaidTicketBase.sol";

error NotEnoughFunds(uint256 funds);
error NotEnoughPaidTicketSpots(uint256 tickets);
error NaffleNotActive();
error InvalidPaidTicketSpots(uint256 spots);
error InvalidNaffleId(uint256 naffleId);
error InvalidNaffleStatus(NaffleBaseStorage.NaffleStatus status);

contract NaffleBaseInternal {
    function _buyTickets(
        uint256 _amount,
        uint256 _naffleId
    ) internal returns (uint256[] memory ticketIds) {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleBaseStorage.Naffle storage naffle = layout.naffles[_naffleId];

        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleBaseStorage.NaffleStatus.ACTIVE && naffle.status != NaffleBaseStorage.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (msg.value < _amount * naffle.ticketPriceInWei) {
            revert NotEnoughFunds(msg.value);
        }
        uint256 ticketSpots = naffle.paidTicketSpots;
        if (naffle.numberOfPaidTickets > naffle.paidTicketSpots) {
            revert NotEnoughPaidTicketSpots(naffle.paidTicketSpots);
        }
        if (
            naffle.status != NaffleBaseStorage.NaffleStatus.ACTIVE ||
            naffle.status != NaffleBaseStorage.NaffleStatus.POSTPONED
        ) {
            revert NaffleNotActive();
        }
        ticketIds = layout.paidTicketContract.mintTickets(
            msg.sender,
            _amount,
            _naffleId,
            naffle.ticketPriceInWei
        );
    }

    function _createNaffle(
        address _ethTokenAddress,
        uint256 _nftId,
        uint256 _paidTicketSpots,
        uint256 _freeTicketSpots,
        uint256 _ticketPriceInWei,
        NaffleBaseStorage.NaffleType _type 
    ) internal returns (uint256 naffleId) {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        ++layout.numberOfNaffles;
        naffleId = layout.numberOfNaffles;
        uint256 freeTicketSpots = 0;
        if (_type == NaffleBaseStorage.NaffleType.UNLIMITED && _paidTicketSpots != 0) {
            // Unlimited naffles don't have an upper limit on paid or free tickets.
            revert InvalidPaidTicketSpots(_paidTicketSpots);
        } else {
            freeTicketSpots = _paidTicketSpots / layout.freeTicketRatio;
        }

        layout.naffles[naffleId] = NaffleBaseStorage.Naffle({
            ethTokenAddress: _ethTokenAddress,
            nftId: _nftId,
            paidTicketSpots: _paidTicketSpots,
            freeTicketSpots: freeTicketSpots,
            numberOfPaidTickets: 0,
            numberOfFreeTickets: 0,
            ticketPriceInWei: _ticketPriceInWei,
            status: NaffleBaseStorage.NaffleStatus.ACTIVE,
            naffleType: _type
        });
    }
    
    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getNafflePlatformRole() internal view returns (bytes32) {
        return NaffleBaseStorage.NAFFLE_PLATFORM_ROLE;
    }

    function _setPaidTicketContract(address _paidTicketContract) internal {
        NaffleBaseStorage.layout().paidTicketContract = IPaidTicketBase(
            _paidTicketContract
        );
    }

    function _setPlatformFee(uint256 _platformFee) internal {
        NaffleBaseStorage.layout().platformFee = _platformFee;
    }

    function _getTicketPriceForNaffle(
        uint256 _naffleId
    ) internal view returns (uint256) {
        return NaffleBaseStorage.layout().naffles[_naffleId].ticketPriceInWei;
    }
    
    function _getFreeTicketRatio() internal view returns (uint256) {
        return NaffleBaseStorage.layout().freeTicketRatio;
    }

    function _setFreeTicketRatio(uint256 _freeTicketRatio) internal {
        NaffleBaseStorage.layout().freeTicketRatio = _freeTicketRatio;
    }
}
