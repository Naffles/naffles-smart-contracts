// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseStorage.sol";
import "../../libraries/NaffleTypes.sol";
import '@solidstate/contracts/interfaces/IERC165.sol';
import '@solidstate/contracts/interfaces/IERC721.sol';
import '@solidstate/contracts/interfaces/IERC1155.sol';
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleBaseInternal.sol";
import "@zksync/contracts/l1/zksync/interfaces/IZkSync.sol";
import "../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBase.sol";
import "../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketView.sol";
import "../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBase.sol";
import "../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketView.sol";
import "@zksync/contracts/l2/system-contracts/interfaces/IL1Messenger.sol";

abstract contract L2NaffleBaseInternal is IL2NaffleBaseInternal, AccessControlInternal {
    function _createNaffle(
        NaffleTypes.CreateZkSyncNaffleParams memory _params
    ) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();

        uint256 freeTicketSpots = 0;
        if (_params.naffleType == NaffleTypes.NaffleType.STANDARD) {
            freeTicketSpots = _params.paidTicketSpots / layout.freeTicketRatio;
        }
        layout.naffles[_params.naffleId] = NaffleTypes.L2Naffle({
            ethTokenAddress: _params.ethTokenAddress,
            owner: _params.owner,
            naffleId: _params.naffleId,
            nftId: _params.nftId,
            paidTicketSpots: _params.paidTicketSpots,
            freeTicketSpots: freeTicketSpots,
            numberOfPaidTickets: 0,
            numberOfOpenEntries: 0,
            ticketPriceInWei: _params.ticketPriceInWei,
            endTime: _params.endTime,
            winningTicketId: 0,
            winningTicketType: NaffleTypes.TicketType.NONE,
            status: NaffleTypes.NaffleStatus.ACTIVE,
            naffleTokenType: _params.naffleTokenType,
            naffleType: _params.naffleType
        });
    }

    function _buyTickets(
        uint256 _amount,
        uint256 _naffleId
    ) internal returns (uint256[] memory ticketIds) {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];
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
        if (naffle.naffleType == NaffleTypes.NaffleType.STANDARD && naffle.numberOfPaidTickets + _amount > naffle.paidTicketSpots) {
            revert NotEnoughPaidTicketSpots(naffle.paidTicketSpots);
        }
        uint256 startingTicketId = naffle.numberOfPaidTickets + 1;
        naffle.numberOfPaidTickets = naffle.numberOfPaidTickets + _amount;
        ticketIds = IL2PaidTicketBase(layout.paidTicketContractAddress).mintTickets(
            msg.sender,
            _amount,
            _naffleId,
            naffle.ticketPriceInWei,
            startingTicketId
        );
    }

    function _useOpenEntryTickets(
        uint256[] memory _ticketIds,
        uint256 _naffleId
    ) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];

        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE && naffle.status != NaffleTypes.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (naffle.numberOfOpenEntries + _ticketIds.length > naffle.freeTicketSpots) {
            revert NotEnoughOpenEntryTicketSpots(naffle.freeTicketSpots);
        }
        uint256 startingTicketId = naffle.numberOfOpenEntries + 1;
        naffle.numberOfOpenEntries = naffle.numberOfOpenEntries + _ticketIds.length;
        IL2OpenEntryTicketBase(layout.openEntryTicketContractAddress).attachToNaffle(_naffleId, _ticketIds, startingTicketId, msg.sender);
    }

    function _adminCancelNaffle(
        uint256 _naffleId
    ) internal returns (bytes32 messageHash){
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];
        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE && naffle.status != NaffleTypes.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(naffle.status);
        }
        naffle.status = NaffleTypes.NaffleStatus.CANCELLED;

        bytes memory message = abi.encode("cancel", _naffleId);
        messageHash = IL1Messenger(layout.l1MessengerContractAddress).sendToL1(message);
    }

    function _ownerDrawWinner(uint256 _naffleId) internal returns (bytes32 messageHash) {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];
        if (naffle.owner != msg.sender) {
            revert NotAllowed();
        }
        return _drawWinnerInternal(naffle, _naffleId);
    }

    function _adminDrawWinner(uint256 _naffleId) internal returns (bytes32 messageHash) {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];
        return _drawWinnerInternal(naffle, _naffleId);
    }

    function _drawWinnerInternal(NaffleTypes.L2Naffle storage naffle, uint256 _naffleId) internal returns (bytes32 messageHash) {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE && naffle.status != NaffleTypes.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (naffle.endTime > block.timestamp) {
            revert NaffleNotEndedYet(naffle.endTime);
        }
        if (naffle.numberOfPaidTickets + naffle.numberOfOpenEntries == 0) {
            revert NoTicketsBought();
        }
        uint256 winningTicketId = _random(naffle.numberOfPaidTickets + naffle.numberOfOpenEntries);
        address winner;
        if (winningTicketId <= naffle.numberOfPaidTickets) {
            naffle.winningTicketType = NaffleTypes.TicketType.PAID;
            naffle.winningTicketId = winningTicketId;
            winner = IL2PaidTicketView(layout.paidTicketContractAddress).getOwnerOfNaffleTicketId(_naffleId, winningTicketId);
        } else {
            naffle.winningTicketType = NaffleTypes.TicketType.OPEN_ENTRY;
            naffle.winningTicketId = winningTicketId - naffle.numberOfPaidTickets;
            winner = IL2OpenEntryTicketView(layout.openEntryTicketContractAddress).getOwnerOfNaffleTicketId(_naffleId, naffle.winningTicketId);
        }
        naffle.status = NaffleTypes.NaffleStatus.FINISHED;

        uint256 totalFundsRaised = naffle.ticketPriceInWei * naffle.numberOfPaidTickets;
        uint256 platformFee = totalFundsRaised * layout.platformFee / 10000;
        uint256 amountToTransfer = totalFundsRaised - platformFee;

        bytes memory message = abi.encode("setWinner", _naffleId, winner);
        messageHash = IL1Messenger(layout.l1MessengerContractAddress).sendToL1(message);
        layout.platformFeesAccumulated = layout.platformFeesAccumulated + platformFee;
        (bool success, ) = msg.sender.call{value: amountToTransfer}("");
        if (!success) {
            revert UnableToSendFunds();
        }
    }

    function _random(uint256 maxValue) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(
              tx.origin,
              blockhash(block.number - 1),
              block.timestamp
        ))) % maxValue + 1;
      }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getPlatformFee() internal view returns (uint256) {
        return L2NaffleBaseStorage.layout().platformFee;
    }

    function _setPlatformFee(uint256 _platformFee) internal {
        L2NaffleBaseStorage.layout().platformFee = _platformFee;
    }

    function _getOpenEntryRatio() internal view returns (uint256) {
        return L2NaffleBaseStorage.layout().freeTicketRatio;
    }

    function _setOpenEntryRatio(uint256 _freeTicketRatio) internal {
        if (_freeTicketRatio == 0) {
            revert OpenTicketRatioCannotBeZero();
        }
        L2NaffleBaseStorage.layout().freeTicketRatio = _freeTicketRatio;
    }

    function _getL1NaffleContractAddress() internal view returns (address) {
        return L2NaffleBaseStorage.layout().l1NaffleContractAddress;
    }

    function _setL1NaffleContractAddress(address _l1NaffleContractAddress) internal {
        L2NaffleBaseStorage.layout().l1NaffleContractAddress = _l1NaffleContractAddress;
    }

    function _getNaffleById(uint256 _id) internal view returns (NaffleTypes.L2Naffle memory) {
        return L2NaffleBaseStorage.layout().naffles[_id];
    }

    function _setPaidTicketContractAddress(address _paidTicketContractAddress) internal {
        L2NaffleBaseStorage.layout().paidTicketContractAddress = _paidTicketContractAddress;
    }

    function _getPaidTicketContractAddress() internal view returns (address) {
        return L2NaffleBaseStorage.layout().paidTicketContractAddress;
    }

    function _setOpenEntryTicketContractAddress(address _openEntryTicketContractAddress) internal {
        L2NaffleBaseStorage.layout().openEntryTicketContractAddress = _openEntryTicketContractAddress;
    }

    function _getOpenEntryTicketContractAddress() internal view returns (address) {
        return L2NaffleBaseStorage.layout().openEntryTicketContractAddress;
    }

    function _setL1MessengerContractAddress(address _l1MessengerContractAddress) internal {
        L2NaffleBaseStorage.layout().l1MessengerContractAddress = _l1MessengerContractAddress;
    }

    function _withdrawPlatformFees(uint256 _amount, address _to) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        if (layout.platformFeesAccumulated < _amount) {
            revert InsufficientFunds();
        }
        layout.platformFeesAccumulated = layout.platformFeesAccumulated - _amount;
        (bool success, ) = _to.call{value: _amount}("");
        if (!success) {
            revert UnableToSendFunds();
        }
    }
}
