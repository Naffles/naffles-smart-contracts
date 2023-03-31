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
    /**
     * @notice create a new naffle.
     * @param _params the parameters for the naffle.
     */
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

        emit L2NaffleCreated(
            _params.naffleId,
            _params.owner,
            _params.ethTokenAddress,
            _params.nftId,
            _params.paidTicketSpots,
            _params.freeTicketSpots,
            _params.ticketPriceInWei,
            _params.endTime,
            _params.naffleTokenType,
            _params.naffleType
        );
    }

    /**
     * @notice buy tickets for a naffle. A call is made to to the paid ticket contract to mint the tickets to the buyer.
     * @dev if an invalid naffle id is passed an InvalidNaffleId error is thrown.
     * @dev if the naffle is in an invalid state an InvalidNaffleStatus error is thrown.
     * @dev if the msg.value is not enough to buy the tickets a NotEnoughFunds error is thrown.
     * @dev if the naffle is a standard naffle and the amount of tickets to buy is greater than the number of paid ticket spots left a NotEnoughPaidTicketSpots error is thrown.
     * @param _amount the amount of tickets to buy
     * @param _naffleId the id of the naffle.
     */
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

        emit TicketsBought(
            _naffleId,
            msg.sender,
            ticketIds,
            naffle.ticketPriceInWei
        );
    }

    /**
     * @notice use open entry tickets for a naffle. A call is made to the open entry ticket contract to attach the tickets to the naffle.
     * @dev if an invalid naffle id is passed an InvalidNaffleId error is thrown.
     * @dev if the naffle is in an invalid state an InvalidNaffleStatus error is thrown.
     * @dev if the number of tickets to use is greater than the number of open entry ticket spots left a NotEnoughOpenEntryTicketSpots error is thrown.
     * @param _ticketIds the ids of the tickets to use.
     * @param _naffleId the id of the naffle.
     */
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

        emit OpenEntryTicketsUsed(
            _naffleId,
            msg.sender,
            _ticketIds
        );
    }

    /**
     * @notice cancel a naffle.
     * @dev if the caller is not the owner of the naffle a NotAllowed error is thrown.
     * @dev if an invalid naffle id is passed an InvalidNaffleId error is thrown.
     * @dev if the naffle is in an invalid state an InvalidNaffleStatus error is thrown.
     * @dev if the naffle is a standard naffle and the naffle is not sold out a NaffleNotSoldOut error is thrown.
     * @param _naffleId the id of the naffle.
     */
    function _ownerCancelNaffle(
        uint256 _naffleId
    ) internal returns (bytes32 messageHash){
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];
        if (naffle.owner != msg.sender) {
            revert NotAllowed();
        }
        if (naffle.endTime > block.timestamp) {
            revert NaffleNotEndedYet(naffle.endTime);
        }
        if (naffle.naffleType == NaffleTypes.NaffleType.UNLIMITED) {
            revert InvalidNaffleType(naffle.naffleType);
        }
        if (naffle.paidTicketSpots == naffle.numberOfPaidTickets) {
            revert NaffleSoldOut();
        }

        return _cancelNaffleInternal(naffle, layout);
    }

    /**
     * @notice cancel a naffle.
     * @dev if an invalid naffle id is passed an InvalidNaffleId error is thrown.
     * @dev if the naffle is in an invalid state an InvalidNaffleStatus error is thrown.
     * @param _naffleId the id of the naffle.
     */
    function _adminCancelNaffle(
        uint256 _naffleId
    ) internal returns (bytes32 messageHash){
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];
        if (naffle.ethTokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        return _cancelNaffleInternal(naffle, layout);
    }

    function _cancelNaffleInternal(
       NaffleTypes.L2Naffle storage _naffle, L2NaffleBaseStorage.Layout storage layout
    ) internal returns (bytes32 messageHash) {
        if (_naffle.status != NaffleTypes.NaffleStatus.ACTIVE && _naffle.status != NaffleTypes.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(_naffle.status);
        }
        _naffle.status = NaffleTypes.NaffleStatus.CANCELLED;

        bytes memory message = abi.encode("cancel", _naffle.naffleId);
        messageHash = IL1Messenger(layout.l1MessengerContractAddress).sendToL1(message);

        emit L2NaffleCancelled(
            _naffle.naffleId,
            messageHash
        );
    }

    /**
     * @notice draw a winner for a naffle. platform fees are taken and the winner is chosen and send to L1.
     * @dev if the caller is not the owner of the naffle a NotAllowed error is thrown.
     * @dev if an invalid naffle id is passed an InvalidNaffleId error is thrown.
     * @dev if the naffle is in an invalid state an InvalidNaffleStatus error is thrown.
     * @dev if the naffle is not finished a NaffleNotEndedYet error is thrown.
     * @dev if there are no tickets a NoTicketsBought error is thrown.
     * @dev if the funds can't get send to the owner a UnableToSendFunds error is thrown.
     * @param _naffleId the id of the naffle.
     */
    function _ownerDrawWinner(uint256 _naffleId) internal returns (bytes32 messageHash) {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];
        if (naffle.owner != msg.sender) {
            revert NotAllowed();
        }
        return _drawWinnerInternal(naffle, _naffleId);
    }


     /**
     * @notice draw a winner for a naffle. platform fees are taken and the winner is chosen and send to L1.
     * @dev if an invalid naffle id is passed an InvalidNaffleId error is thrown.
     * @dev if the naffle is in an invalid state an InvalidNaffleStatus error is thrown.
     * @dev if the naffle is not finished a NaffleNotEndedYet error is thrown.
     * @dev if there are no tickets a NoTicketsBought error is thrown.
     * @dev if the funds can't get send to the owner a UnableToSendFunds error is thrown.
     * @param _naffleId the id of the naffle.
     */
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

        emit L2NaffleFinished(
            _naffleId,
            winner,
            messageHash
        );
    }

    /**
     * @notice gets a random number, this method is not secure and should be used for testing purposes only.
     * @dev the random number is generated by hashing the tx.origin, the blockhash of the previous block and the current timestamp.
     * @dev the random number is between 1 and maxValue.
     * @param maxValue the maximum value of the random number.
     * @return randomNumber the random number.
     */
    function _random(uint256 maxValue) internal view returns (uint256 randomNumber) {
        randomNumber = uint256(keccak256(abi.encodePacked(
              tx.origin,
              blockhash(block.number - 1),
              block.timestamp
        ))) % maxValue + 1;
      }

    /**
     * @notice gets the admin role.
     * @return adminRole the admin role.
     */
    function _getAdminRole() internal view returns (bytes32 adminRole) {
        adminRole = AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    /**
     * @notice gets the platform fee
     * @return platformFee the platform fee.
     */
    function _getPlatformFee() internal view returns (uint256 platformFee) {
        platformFee = L2NaffleBaseStorage.layout().platformFee;
    }

    /**
     * @notice sets the platform fee
     * @param _platformFee the platform fee.
     */
    function _setPlatformFee(uint256 _platformFee) internal {
        L2NaffleBaseStorage.layout().platformFee = _platformFee;
    }

    /**
     * @notice gets the paid ticket to open entry ratio.
     * @return openEntryRatio the paid ticket to open entry ratio.
     */
    function _getOpenEntryRatio() internal view returns (uint256 openEntryRatio) {
        openEntryRatio = L2NaffleBaseStorage.layout().freeTicketRatio;
    }

    /**
     * @notice sets the paid ticket to open entry ratio.
     * @param _freeTicketRatio the paid ticket to open entry ratio.
     */
    function _setOpenEntryRatio(uint256 _freeTicketRatio) internal {
        if (_freeTicketRatio == 0) {
            revert OpenTicketRatioCannotBeZero();
        }
        L2NaffleBaseStorage.layout().freeTicketRatio = _freeTicketRatio;
    }

    /**
     * @notice gets the L1 naffle contract address
     * @return l1NaffleContractAddress the L1 naffle contract address.
     */
    function _getL1NaffleContractAddress() internal view returns (address l1NaffleContractAddress) {
        l1NaffleContractAddress = L2NaffleBaseStorage.layout().l1NaffleContractAddress;
    }

    /**
     * @notice sets the L1 naffle contract address
     * @param _l1NaffleContractAddress the L1 naffle contract address.
     */
    function _setL1NaffleContractAddress(address _l1NaffleContractAddress) internal {
        L2NaffleBaseStorage.layout().l1NaffleContractAddress = _l1NaffleContractAddress;
    }

    /**
     * @notice gets the naffle by id.
     * @param _id the naffle id.
     * @return naffle the naffle.
     */
    function _getNaffleById(uint256 _id) internal view returns (NaffleTypes.L2Naffle memory naffle) {
        naffle = L2NaffleBaseStorage.layout().naffles[_id];
    }

    /**
     * @notice sets the paid ticket contract address
     * @param _paidTicketContractAddress the paid ticket contract address.
     */
    function _setPaidTicketContractAddress(address _paidTicketContractAddress) internal {
        L2NaffleBaseStorage.layout().paidTicketContractAddress = _paidTicketContractAddress;
    }

    /**
     * @notice gets the paid ticket contract address
     * @return paidTicketContractAddress the paid ticket contract address.
     */
    function _getPaidTicketContractAddress() internal view returns (address paidTicketContractAddress) {
        paidTicketContractAddress = L2NaffleBaseStorage.layout().paidTicketContractAddress;
    }

    /**
     * @notice sets the open entry ticket contract address
     * @param _openEntryTicketContractAddress the open entry ticket contract address.
     */
    function _setOpenEntryTicketContractAddress(address _openEntryTicketContractAddress) internal {
        L2NaffleBaseStorage.layout().openEntryTicketContractAddress = _openEntryTicketContractAddress;
    }

    /**
     * @notice gets the open entry ticket contract address
     * @return openEntryTicketContractAddress the open entry ticket contract address.
     */
    function _getOpenEntryTicketContractAddress() internal view returns (address openEntryTicketContractAddress) {
        openEntryTicketContractAddress = L2NaffleBaseStorage.layout().openEntryTicketContractAddress;
    }

    /**
     * @notice sets the L1 messenger contract address
     * @param _l1MessengerContractAddress the L1 messenger contract address.
     */
    function _setL1MessengerContractAddress(address _l1MessengerContractAddress) internal {
        L2NaffleBaseStorage.layout().l1MessengerContractAddress = _l1MessengerContractAddress;
    }

    /**
     * @notice withdraw the platform fees to the specified address.
     * @param _amount the amount to withdraw.
     * @param _to the address to withdraw the funds to.
     */
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
