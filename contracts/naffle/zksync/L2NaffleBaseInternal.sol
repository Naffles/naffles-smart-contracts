// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseStorage.sol";
import "../../libraries/NaffleTypes.sol";
import "../../libraries/Signature.sol";
import '@solidstate/contracts/interfaces/IERC165.sol';
import '@solidstate/contracts/interfaces/IERC721.sol';
import '@solidstate/contracts/interfaces/IERC1155.sol';
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleBaseInternal.sol";
import "@matterlabs/zksync-contracts/l1/contracts/zksync/interfaces/IZkSync.sol";
import "../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBase.sol";
import "../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBase.sol";
import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IL1Messenger.sol";

abstract contract L2NaffleBaseInternal is IL2NaffleBaseInternal, AccessControlInternal {
    bytes32 internal constant VRF_ROLE = keccak256("VRF_MANAGER");
    uint256 internal constant DENOMINATOR = 10000;

    /**
     * @notice create a new naffle.
     * @param _params the parameters for the naffle.
     */
    function _createNaffle(
        NaffleTypes.CreateZkSyncNaffleParams memory _params
    ) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();

        uint256 openEntryTicketSpots = 0;
        if (_params.naffleType == NaffleTypes.NaffleType.STANDARD) {
            openEntryTicketSpots = _params.paidTicketSpots / layout.openEntryTicketRatio;
        }

        layout.naffles[_params.naffleId] = NaffleTypes.L2Naffle({
            naffleTokenInformation: _params.naffleTokenInformation,
            owner: _params.owner,
            naffleId: _params.naffleId,
            paidTicketSpots: _params.paidTicketSpots,
            openEntryTicketSpots: openEntryTicketSpots,
            numberOfPaidTickets: 0,
            numberOfOpenEntries: 0,
            ticketPriceInWei: _params.ticketPriceInWei,
            endTime: _params.endTime,
            winningTicketId: 0,
            status: NaffleTypes.NaffleStatus.ACTIVE,
            naffleType: _params.naffleType
        });

        emit L2NaffleCreated(
            _params.naffleTokenInformation,
            _params.naffleId,
            _params.owner,
            _params.paidTicketSpots,
            openEntryTicketSpots,
            _params.ticketPriceInWei,
            _params.endTime,
            _params.naffleType
        );
    }

    /**
     * @notice Buy tickets for a naffle. A call is made to the paid ticket contract to mint the tickets to the buyer.
     * @dev If an invalid naffle id is passed, an InvalidNaffleId error is thrown.
     * @dev If the naffle is in an invalid state, an InvalidNaffleStatus error is thrown.
     * @dev If the msg.value is not enough to buy the tickets, a NotEnoughFunds error is thrown.
     * @dev If the naffle is a standard naffle and the amount of tickets to buy is greater than the number of paid ticket spots left, a NotEnoughPaidTicketSpots error is thrown.
     * @param _amount The amount of tickets to buy.
     * @param _naffleId The id of the naffle.
     */
    function _buyTickets(
        uint256 _amount,
        uint256 _naffleId
    ) internal returns (uint256[] memory ticketIds) {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];

        if (naffle.naffleTokenInformation.tokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE && naffle.status != NaffleTypes.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(naffle.status);
        }

        uint256 totalPrice = _amount * naffle.ticketPriceInWei;
        if (msg.value < totalPrice) {
            revert NotEnoughFunds(msg.value);
        }

        uint256 newPaidTickets = naffle.numberOfPaidTickets + _amount;
        if (naffle.naffleType == NaffleTypes.NaffleType.STANDARD && newPaidTickets > naffle.paidTicketSpots) {
            revert NotEnoughPaidTicketSpots(naffle.paidTicketSpots);
        }

        uint256 startingTicketId = naffle.numberOfPaidTickets + 1;
        naffle.numberOfPaidTickets = newPaidTickets;

        IL2PaidTicketBase(layout.paidTicketContractAddress).mintTickets(
            msg.sender,
            _amount,
            _naffleId,
            naffle.ticketPriceInWei,
            startingTicketId
        );

        emit TicketsBought(
            _naffleId,
            msg.sender,
            _amount,
            startingTicketId,
            naffle.ticketPriceInWei
        );

        _checkIfNaffleIsFinished(naffle);
    }

    /**
     * @notice refund and burns tickets for a naffle.
     * @param _naffleId id of the naffle.
     * @param _openEntryTicketIds ids of the open entry tickets.
     * @param _owner owner of the tickets.
     */
    function _refundTicketsForNaffle(
        uint256 _naffleId,
        uint256[] memory _openEntryTicketIds,
        address _owner
    ) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];

        if (naffle.status != NaffleTypes.NaffleStatus.CANCELLED) {
            revert InvalidNaffleStatus(naffle.status);
        }

        if (_openEntryTicketIds.length > 0) {
            IL2OpenEntryTicketBase(layout.openEntryTicketContractAddress).detachFromNaffle(
                _naffleId,
                _openEntryTicketIds
            );
        }

        IL2PaidTicketBase ticketBase = IL2PaidTicketBase(layout.paidTicketContractAddress);
        uint256 amountOfPaidTickets = ticketBase.balanceOf(_owner, _naffleId);
        ticketBase.refundAndBurnTickets(
            _naffleId,
            amountOfPaidTickets,
            _owner
        );

        (bool success, ) = _owner.call{value: amountOfPaidTickets * naffle.ticketPriceInWei}("");
        if (!success) {
            revert UnableToSendFunds();
        }
    }

    /**
     * @notice Use open entry tickets for a naffle. A call is made to the open entry ticket contract to attach the tickets to the naffle.
     * @dev If an invalid naffle id is passed, an InvalidNaffleId error is thrown.
     * @dev If the naffle is in an invalid state, an InvalidNaffleStatus error is thrown.
     * @dev If the number of tickets to use is greater than the number of open entry ticket spots left, a NotEnoughOpenEntryTicketSpots error is thrown.
     * @param _ticketIds The ids of the tickets to use.
     * @param _naffleId The id of the naffle.
     */
    function _useOpenEntryTickets(
        uint256[] memory _ticketIds,
        uint256 _naffleId
    ) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];

        if (naffle.naffleTokenInformation.tokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE && naffle.status != NaffleTypes.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(naffle.status);
        }

        uint256 newOpenEntries = naffle.numberOfOpenEntries + _ticketIds.length;
        if (newOpenEntries > naffle.openEntryTicketSpots) {
            revert NotEnoughOpenEntryTicketSpots(naffle.openEntryTicketSpots);
        }

        uint256 startingTicketId = naffle.numberOfOpenEntries + 1;
        naffle.numberOfOpenEntries = newOpenEntries;

        IL2OpenEntryTicketBase(layout.openEntryTicketContractAddress).attachToNaffle(_naffleId, _ticketIds, startingTicketId, msg.sender);

        emit OpenEntryTicketsUsed(
            _naffleId,
            msg.sender,
            _ticketIds
        );

        _checkIfNaffleIsFinished(naffle);
    }

    /**
     * @notice checks if the naffle is sold out, if so it requests a random number for the naffle
     * @param _naffle the naffle to check.
     */
    function _checkIfNaffleIsFinished(
        NaffleTypes.L2Naffle storage _naffle
    ) internal {
        if (_naffle.numberOfOpenEntries == _naffle.openEntryTicketSpots && _naffle.numberOfPaidTickets == _naffle.paidTicketSpots) {
            _requestRandomNumber(_naffle.naffleId);
        }
    }

    /**
     * @notice emits event to request a random number for a naffle.
     * @dev if the naffle has already had a random number requested an error is thrown.
     * @param _naffleId the naffleId to request a random number for.
     */
    function _requestRandomNumber(uint256 _naffleId) private {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        bool randomNumberRequested = layout.naffleRandomNumberRequested[_naffleId];
        if (randomNumberRequested == true) {
            revert RandomNumberAlreadyRequested();
        }
        layout.naffleRandomNumberRequested[_naffleId] = true;
        emit RandomNumberRequested(_naffleId);
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

        if (naffle.naffleTokenInformation.tokenAddress == address(0)) {
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
      * @notice draw a winner for a naffle.
     * @dev if an invalid naffle id is passed an InvalidNaffleId error is thrown.
     * @dev if the naffle is in an invalid state an InvalidNaffleStatus error is thrown.
     * @dev if the naffle is not finished a NaffleNotEndedYet error is thrown.
     * @dev if there are no tickets a NoTicketsBought error is thrown.
     * @dev if the funds can't get send to the owner a UnableToSendFunds error is thrown.
     * @param _naffleId the id of the naffle.
     */
    function _drawWinner(uint256 _naffleId) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];

        // only owners can draw winners pre end time when not all tickets are sold.
        if (naffle.endTime > block.timestamp && naffle.paidTicketSpots != naffle.numberOfPaidTickets) {
            revert NaffleNotEndedYet(naffle.endTime);
        }

        _drawWinnerInternal(naffle);
    }

    function _ownerDrawWinner(uint256 _naffleId) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];

        if (naffle.owner != msg.sender) {
            revert NotAllowed();
        }

        _drawWinnerInternal(naffle);
    }

    function _drawWinnerInternal(NaffleTypes.L2Naffle storage naffle) private {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        if (naffle.naffleTokenInformation.tokenAddress == address(0)) {
            revert InvalidNaffleId(naffle.naffleId);
        }

        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE && naffle.status != NaffleTypes.NaffleStatus.POSTPONED) {
            revert InvalidNaffleStatus(naffle.status);
        }

        if (naffle.numberOfPaidTickets + naffle.numberOfOpenEntries == 0) {
            revert NoTicketsBought();
        }

         _requestRandomNumber(naffle.naffleId);
    }

    /**
     * @notice set a winner for a naffle based on a random number.
     *         platform fees are taken and the winner is chosen and send to L1.
     * @dev if the funds can't get send to the owner a UnableToSendFunds error is thrown.
     * @param _naffleId the id of the naffle.
     * @param _randomNumber the random number that was generated by the Chainlink VRF.
     * @param _platformDiscountInPercent the platform discount in percent.
     */
    function _setWinner(
        uint256 _naffleId,
        uint256 _randomNumber,
        address _winner,
        uint256 _platformDiscountInPercent
    ) internal returns (bytes32 messageHash) {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];

        uint256 winningTicketId = _randomNumber % (naffle.numberOfPaidTickets + naffle.numberOfOpenEntries) + 1;

        naffle.winningTicketId = winningTicketId;
        naffle.status = NaffleTypes.NaffleStatus.FINISHED;
        uint256 totalFundsRaised = naffle.ticketPriceInWei * naffle.numberOfPaidTickets;
        uint256 platformFee = totalFundsRaised * layout.platformFee / DENOMINATOR;

        if (_platformDiscountInPercent > 0) {
            platformFee = platformFee * (DENOMINATOR - _platformDiscountInPercent) / DENOMINATOR;
        }

        uint256 amountToTransfer = totalFundsRaised - platformFee;

        bytes memory message = abi.encode("setWinner", _naffleId, _winner);
        messageHash = IL1Messenger(layout.l1MessengerContractAddress).sendToL1(message);

        layout.platformFeesAccumulated = layout.platformFeesAccumulated + platformFee;
        (bool success, ) = naffle.owner.call{value: amountToTransfer}("");
        if (!success) {
            revert UnableToSendFunds();
        }

        emit L2NaffleFinished(
            _naffleId,
            _winner,
            naffle.winningTicketId,
            messageHash
        );
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

    /**
     * @notice postpone a naffle.
     * @param _naffleId the id of the naffle.
     * @param _newEndTime the new end time of the naffle.
     */
    function _postponeNaffle(
        uint256 _naffleId,
        uint256 _newEndTime
    ) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];
        if (naffle.naffleTokenInformation.tokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }
        if (naffle.naffleType == NaffleTypes.NaffleType.UNLIMITED) {
            revert InvalidNaffleType(naffle.naffleType);
        }
        if (naffle.status != NaffleTypes.NaffleStatus.ACTIVE) {
            revert InvalidNaffleStatus(naffle.status);
        }
        if (naffle.endTime > block.timestamp) {
            revert NaffleNotFinished(naffle.endTime);
        }
        if (naffle.owner != msg.sender) {
            revert NotNaffleOwner(naffle.owner);
        }
        if (_newEndTime < block.timestamp || _newEndTime > block.timestamp + layout.maxPostponeTime) {
            revert InvalidEndTime(_newEndTime);
        }
        naffle.status = NaffleTypes.NaffleStatus.POSTPONED;
        naffle.endTime = _newEndTime;

        emit L2NafflePostponed(
            _naffleId,
            _newEndTime
        );
    }

    /**
     * @notice gets the admin role.
     * @return adminRole the admin role.
     */
    function _getAdminRole() internal pure returns (bytes32 adminRole) {
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
        openEntryRatio = L2NaffleBaseStorage.layout().openEntryTicketRatio;
    }

    /**
     * @notice sets the paid ticket to open entry ratio.
     * @param _openEntryRatio the paid ticket to open entry ratio.
     */
    function _setOpenEntryRatio(uint256 _openEntryRatio) internal {
        if (_openEntryRatio == 0) {
            revert OpenTicketRatioCannotBeZero();
        }
        L2NaffleBaseStorage.layout().openEntryTicketRatio = _openEntryRatio;
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
     * @notice sets the max postpone time
     * @param _maxPostponeTime the max postpone time.
     */
    function _setMaxPostponeTime(uint256 _maxPostponeTime) internal {
        L2NaffleBaseStorage.layout().maxPostponeTime = _maxPostponeTime;
    }

    /**
     * @notice gets the max postpone time
     * @return maxPostponeTime the max postpone time.
     */
    function _getMaxPostponeTime() internal view returns (uint256 maxPostponeTime) {
        maxPostponeTime = L2NaffleBaseStorage.layout().maxPostponeTime;
    }

    /**
     * @notice sets the signature signer address.
     * @param _signatureSignerAddress the signature signer address.
     */
    function _setSignatureSignerAddress(address _signatureSignerAddress) internal {
        L2NaffleBaseStorage.layout().signatureSigner = _signatureSignerAddress;
    }

    /**
     * @notice gets the domain signature.
     * @param _domainSignature the domain signature.
     */
    function _setDomainSignature(bytes32 _domainSignature) internal {
        L2NaffleBaseStorage.layout().domainSignature = _domainSignature;
    }


    /**
     * @notice gets the domain signature.
     * @param _domainName the domain signature.
     */
    function _setDomainName(string memory _domainName) internal {
        L2NaffleBaseStorage.layout().domainName = _domainName;
    }
}
