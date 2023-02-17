// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {NaffleBaseStorage} from "./NaffleBaseStorage.sol";
import {AccessControlStorage} from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import {IPaidTicketBase} from "../../../../../interfaces/tokens/zksync/tickets/paid/base/IPaidTicketBase.sol";
import {NaffleTypes} from "../../../../libraries/NaffleTypes.sol";


error NotEnoughFunds(uint256 funds);
error NotEnoughPaidTicketSpots(uint256 tickets);
error NaffleNotActive();
error InvalidNaffleId(uint256 naffleId);
error InvalidNaffleStatus(NaffleTypes.NaffleStatus status);
error NotNaffleOwner(uint256 naffleId);
error NaffleNotFinished(uint256 naffleId);
error NaffleIsFinished(uint256 naffleId);
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
        NaffleTypes.Naffle storage naffle = layout.naffles[_naffleId];

        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE && naffle.status != NaffleTypes.NaffleStatus.POSTPONED) {
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
            naffle.status != NaffleTypes.NaffleStatus.ACTIVE ||
            naffle.status != NaffleTypes.NaffleStatus.POSTPONED
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
        NaffleTypes.TokenContractType _naffleTokenType,
        NaffleTypes.NaffleType _naffleType
    ) internal returns (uint256 naffleId) {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();

        uint256 freeTicketSpots = 0;
        if (_naffleType == NaffleTypes.NaffleType.STANDARD) {
            freeTicketSpots = _paidTicketSpots / layout.freeTicketRatio;
        }
        layout.naffles[naffleId] = NaffleTypes.Naffle({
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
            winningTicketType: NaffleTypes.TicketType.NONE,
            naffleTokenType: _naffleTokenType,
            status: NaffleTypes.NaffleStatus.ACTIVE,
            naffleType: _naffleType 
        });
    }

    function _setWinner(
        uint256 _naffleId,
        uint256 _ticketId,
        uint256 _winningNumber,
        NaffleTypes.TicketType _winningTicketType
    ) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleTypes.Naffle storage naffle = layout.naffles[_naffleId];

        naffle.winningTicketId = _winningNumber;
        naffle.winningTicketType = _winningTicketType;
      
        // TODO reduce platform fee for passholders
        uint256 totalFundsInNaffle = naffle.numberOfPaidTickets * naffle.ticketPriceInWei * 10000;
        uint256 amountToSendToOwner = totalFundsInNaffle - totalFundsInNaffle * layout.platformFee / 10000;
        layout.platformFeeBalance += (totalFundsInNaffle - amountToSendToOwner) / 1000;
        amountToSendToOwner = amountToSendToOwner / 10000;

        (bool success, ) = msg.sender.call{value: amountToSendToOwner}("");
        if (!success) { revert UnableToWithdraw({amount: amountToSendToOwner});}

    }

   function _runNaffle(uint256 _naffleId) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleTypes.Naffle storage naffle = layout.naffles[_naffleId];
    
        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE || naffle.status != NaffleTypes.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (naffle.endTime > block.timestamp) {
            revert NaffleNotFinished(_naffleId);
        }
        if (naffle.numberOfPaidTickets == naffle.paidTicketSpots) {
            revert NaffleIsFinished(_naffleId);
        }
        naffle.status = NaffleTypes.NaffleStatus.SELECTING_WINNER;

        // call l1 contract to select winner
    }

    function postponeNaffle(uint256 _naffleId, NaffleTypes.PostponeTime _postponeTime) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleTypes.Naffle storage naffle = layout.naffles[_naffleId];

        if (msg.sender != naffle.owner) {
            revert NotNaffleOwner(_naffleId);
        }
        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (naffle.endTime < block.timestamp) {
            revert NaffleNotFinished(_naffleId);
        }
        if (naffle.numberOfPaidTickets == naffle.paidTicketSpots) {
            revert NaffleIsFinished(_naffleId);
        }
        naffle.status = NaffleTypes.NaffleStatus.POSTPONED;
    }

    function cancelNaffle(uint256 _naffleId) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleTypes.Naffle storage naffle = layout.naffles[_naffleId];

        if (msg.sender != naffle.owner) {
            revert NotNaffleOwner(_naffleId);
        }

        _internalCancelNaffle(_naffleId, naffle);
    }

    function adminCancelnaffle(uint256 _naffleId) internal {
        NaffleBaseStorage.Layout storage layout = NaffleBaseStorage.layout();
        NaffleTypes.Naffle storage naffle = layout.naffles[_naffleId];

        _internalCancelNaffle(_naffleId, naffle);
    }

    function _internalCancelNaffle(uint256 _naffleId, NaffleTypes.Naffle storage naffle) internal {
        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (naffle.endTime < block.timestamp) {
            revert NaffleNotFinished(_naffleId);
        }
        if (naffle.numberOfPaidTickets == naffle.paidTicketSpots) {
            revert NaffleIsFinished(_naffleId);
        }
        naffle.status = NaffleTypes.NaffleStatus.CLOSED;
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
    
    function getPostponeTime(NaffleTypes.PostponeTime _postponeTime)
        internal
        pure
        returns (uint256)
    {
        if (_postponeTime == NaffleTypes.PostponeTime.ONE_DAY) {
            return 1 days;
        } else if (_postponeTime == NaffleTypes.PostponeTime.TWO_DAYS) {
            return 2 days;
        } else if (_postponeTime == NaffleTypes.PostponeTime.THREE_DAYS) {
            return 3 days;
        } else if (_postponeTime == NaffleTypes.PostponeTime.FOUR_DAYS) {
            return 4 days;
        } else if (_postponeTime == NaffleTypes.PostponeTime.FIVE_DAYS) {
            return 5 days;
        } else if (_postponeTime == NaffleTypes.PostponeTime.SIX_DAYS) {
            return 6 days;
        } else if (_postponeTime == NaffleTypes.PostponeTime.ONE_WEEK) {
            return 7 days;
        } else {
            revert InvalidPostponeTime();
        }
    }
}
