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
error NotNaffleOwner(uint256 naffleId);
error NaffleNotFinished(uint256 naffleId);
error NaffleIsFinished(uint256 naffleId);
error InvalidEndTime(uint256 endTime);
error InvalidPostponeTime();
error InvalidWinningNumber(uint256 winningNumber);
error InsufficientPlatformFeeBalance();
error UnableToWithdraw(uint256 amount);

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
        address _owner,
        uint256 _nftId,
        uint256 _paidTicketSpots,
        uint256 _endTime,
        uint256 _ticketPriceInWei,
        NaffleBaseStorage.NaffleType _type 
    ) internal returns (uint256 naffleId) {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();

        if (block.timestamp + layout.minimumNaffleDuration < _endTime) {
            revert InvalidEndTime(_endTime);
        }

        ++layout.numberOfNaffles;
        naffleId = layout.numberOfNaffles;
        uint256 freeTicketSpots = 0;

        if (
            (_type == NaffleBaseStorage.NaffleType.UNLIMITED && _paidTicketSpots != 0) ||
            _paidTicketSpots < layout.minimumPaidTicketSpots
        ) {
            // Unlimited naffles don't have an upper limit on paid or free tickets.
            revert InvalidPaidTicketSpots(_paidTicketSpots);
        } else {
            freeTicketSpots = _paidTicketSpots / layout.freeTicketRatio;
        }

        layout.naffles[naffleId] = NaffleBaseStorage.Naffle({
            ethTokenAddress: _ethTokenAddress,
            owner: _owner,
            nftId: _nftId,
            paidTicketSpots: _paidTicketSpots,
            freeTicketSpots: freeTicketSpots,
            numberOfPaidTickets: 0,
            numberOfFreeTickets: 0,
            ticketPriceInWei: _ticketPriceInWei,
            endTime: _endTime,
            winningTicketId: 0, 
            winningTicketType: NaffleBaseStorage.TicketType.NONE,
            status: NaffleBaseStorage.NaffleStatus.ACTIVE,
            naffleType: _type
        });
    }

    function postponeNaffle(uint256 _naffleId, NaffleBaseStorage.PostponeTime _postponeTime) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleBaseStorage.Naffle storage naffle = layout.naffles[_naffleId];

        if (msg.sender != naffle.owner) {
            revert NotNaffleOwner(_naffleId);
        }
        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleBaseStorage.NaffleStatus.ACTIVE) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (naffle.endTime < block.timestamp) {
            revert NaffleNotFinished(_naffleId);
        }
        if (naffle.numberOfPaidTickets == naffle.paidTicketSpots) {
            revert NaffleIsFinished(_naffleId);
        }
        naffle.status = NaffleBaseStorage.NaffleStatus.POSTPONED;
    }

    function cancelNaffle(uint256 _naffleId) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleBaseStorage.Naffle storage naffle = layout.naffles[_naffleId];

        if (msg.sender != naffle.owner) {
            revert NotNaffleOwner(_naffleId);
        }

        _internalCancelNaffle(_naffleId, naffle);
    }

    function adminCancelnaffle(uint256 _naffleId) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleBaseStorage.Naffle storage naffle = layout.naffles[_naffleId];

        _internalCancelNaffle(_naffleId, naffle);
    }

    function _internalCancelNaffle(uint256 _naffleId, NaffleBaseStorage.Naffle storage naffle) internal {
        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleBaseStorage.NaffleStatus.ACTIVE) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (naffle.endTime < block.timestamp) {
            revert NaffleNotFinished(_naffleId);
        }
        if (naffle.numberOfPaidTickets == naffle.paidTicketSpots) {
            revert NaffleIsFinished(_naffleId);
        }
        naffle.status = NaffleBaseStorage.NaffleStatus.CLOSED;
    }

    function _selectWinner(uint256 _winningNumber, uint256 _naffleId) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleBaseStorage.Naffle storage naffle = layout.naffles[_naffleId];
    
        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleBaseStorage.NaffleStatus.ACTIVE || naffle.status != NaffleBaseStorage.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (naffle.endTime > block.timestamp) {
            revert NaffleNotFinished(_naffleId);
        }
        if (naffle.numberOfPaidTickets == naffle.paidTicketSpots) {
            revert NaffleIsFinished(_naffleId);
        }
        if (_winningNumber > naffle.numberOfPaidTickets + naffle.numberOfFreeTickets) {
            revert InvalidWinningNumber(_winningNumber);
        }
        if (_winningNumber <= naffle.numberOfPaidTickets) {
            naffle.winningTicketId = _winningNumber;
            naffle.winningTicketType = NaffleBaseStorage.TicketType.PAID;
        } else {
            naffle.winningTicketId = _winningNumber - naffle.numberOfPaidTickets;
            naffle.winningTicketType = NaffleBaseStorage.TicketType.FREE;
        }
        naffle.status = NaffleBaseStorage.NaffleStatus.FINISHED;

        // TODO reduce platform fee for passholders
        uint256 totalFundsInNaffle = naffle.numberOfPaidTickets * naffle.ticketPriceInWei * 10000;
        uint256 amountToSendToOwner = totalFundsInNaffle - totalFundsInNaffle * layout.platformFee / 10000;
        layout.platformFeeBalance += (totalFundsInNaffle - amountToSendToOwner) / 1000;
        amountToSendToOwner = amountToSendToOwner / 10000;

        (bool success, ) = msg.sender.call{value: amountToSendToOwner}("");
        if (!success) { revert UnableToWithdraw({amount: amountToSendToOwner});}
    }

    function _adminPlatformFeeWithdraw(uint256 _amount) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        if (layout.platformFeeBalance < _amount) {
            revert InsufficientPlatformFeeBalance();
        }
        layout.platformFeeBalance -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        if (!success) { revert UnableToWithdraw({amount: _amount});}
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

    function _getMinimumNaffleDuration() internal view returns (uint256) {
        return NaffleBaseStorage.layout().minimumNaffleDuration;
    }

    function _setMinimumNaffleDuration(uint256 _minimumNaffleDuration) internal {
        NaffleBaseStorage.layout().minimumNaffleDuration = _minimumNaffleDuration;
    }

    function _getMinimumPaidTicketSpots() internal view returns (uint256) {
        return NaffleBaseStorage.layout().minimumPaidTicketSpots;
    }

    function _setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) internal {
        NaffleBaseStorage.layout().minimumPaidTicketSpots = _minimumPaidTicketSpots;
    }

    function getPostponeTime(NaffleBaseStorage.PostponeTime _postponeTime)
        internal
        pure
        returns (uint256)
    {
        if (_postponeTime == NaffleBaseStorage.PostponeTime.ONE_DAY) {
            return 1 days;
        } else if (_postponeTime == NaffleBaseStorage.PostponeTime.TWO_DAYS) {
            return 2 days;
        } else if (_postponeTime == NaffleBaseStorage.PostponeTime.THREE_DAYS) {
            return 3 days;
        } else if (_postponeTime == NaffleBaseStorage.PostponeTime.FOUR_DAYS) {
            return 4 days;
        } else if (_postponeTime == NaffleBaseStorage.PostponeTime.FIVE_DAYS) {
            return 5 days;
        } else if (_postponeTime == NaffleBaseStorage.PostponeTime.SIX_DAYS) {
            return 6 days;
        } else if (_postponeTime == NaffleBaseStorage.PostponeTime.ONE_WEEK) {
            return 7 days;
        } else {
            revert InvalidPostponeTime();
        }
    }
}
