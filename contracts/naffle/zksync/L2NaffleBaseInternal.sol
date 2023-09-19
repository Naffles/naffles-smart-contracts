// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "./L2NaffleBaseStorage.sol";
import "../../libraries/NaffleTypes.sol";
import '@solidstate/contracts/interfaces/IERC165.sol';
import '@solidstate/contracts/interfaces/IERC721.sol';
import '@solidstate/contracts/interfaces/IERC1155.sol';
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleBaseInternal.sol";
import "@matterlabs/zksync-contracts/l1/contracts/zksync/interfaces/IZkSync.sol";
import "../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBase.sol";
import "../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketView.sol";
import "../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBase.sol";
import "../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketView.sol";
import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IL1Messenger.sol";

abstract contract L2NaffleBaseInternal is IL2NaffleBaseInternal, AccessControlInternal {
    bytes32 internal constant VRF_ROLE = keccak256("VRF_MANAGER");
    uint256 internal constant NUMERATOR = 10_000;
    uint256 internal constant DENOMINATOR = 10_000;
    uint256 internal constant SECONDS_IN_ONE_MONTH = 2_678_400;
    uint256 internal constant SECONDS_IN_THREE_MONTHS = 7_776_000;
    uint256 internal constant SECONDS_IN_SIX_MONTHS = 15_638_400;
    uint256 internal constant SECONDS_IN_TWELVE_MONTHS = 31_536_000;
    
    //=============================================================================
    // NAFFLE FUNCTIONS
    // _createNaffle
    // _checkIfNaffleIsFinished
    // _requestRandomNumber
    // _ownerCancelNaffle
    // _adminCancelNaffle
    // _cancelNaffleInternal
    // _ownerDrawWinner
    // _drawWinnerInternal
    // _setWinner
    // _postponeNaffle
    //=============================================================================
    
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
            ethTokenAddress: _params.ethTokenAddress,
            owner: _params.owner,
            naffleId: _params.naffleId,
            nftId: _params.nftId,
            paidTicketSpots: _params.paidTicketSpots,
            openEntryTicketSpots: openEntryTicketSpots,
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
            openEntryTicketSpots,
            _params.ticketPriceInWei,
            _params.endTime,
            _params.naffleType,
            _params.naffleTokenType
        );
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
        if (naffle.ethTokenAddress == address(0)) {
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
     */
    function _setWinner(uint256 _naffleId, uint256 _randomNumber) internal returns (bytes32 messageHash) {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        NaffleTypes.L2Naffle storage naffle = layout.naffles[_naffleId];

        uint256 winningTicketId = _randomNumber % (naffle.numberOfPaidTickets + naffle.numberOfOpenEntries) + 1;

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
        uint256 platformFee = totalFundsRaised * layout.platformFee / DENOMINATOR;
        uint256 amountToTransfer = totalFundsRaised - platformFee;

        bytes memory message = abi.encode("setWinner", _naffleId, winner);
        messageHash = IL1Messenger(layout.l1MessengerContractAddress).sendToL1(message);

        layout.platformFeesAccumulated = layout.platformFeesAccumulated + platformFee;
        (bool success, ) = naffle.owner.call{value: amountToTransfer}("");
        if (!success) {
            revert UnableToSendFunds();
        }

        emit L2NaffleFinished(
            _naffleId,
            winner,
            naffle.winningTicketId,
            messageHash
        );
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
        if (naffle.ethTokenAddress == address(0)) {
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
    //=============================================================================
    // TICKET INTERACTIONS
    // _buyTickets
    // _refundTicketsForNaffle
    // _redeemOpenEntryTickets
    // _useOpenEntryTickets
    //=============================================================================
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

        if (naffle.ethTokenAddress == address(0)) {
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

        _checkIfNaffleIsFinished(naffle);
    }

    /**
     * @notice refund and burns tickets for a naffle.
     * @param _naffleId id of the naffle.
     * @param _openEntryTicketIds ids of the open entry tickets.
     * @param _paidTicketIds ids of the paid tickets.
     * @param _owner owner of the tickets.
     */
    function _refundTicketsForNaffle(
        uint256 _naffleId,
        uint256[] memory _openEntryTicketIds,
        uint256[] memory _paidTicketIds,
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
        if (_paidTicketIds.length > 0) {
            IL2PaidTicketBase(layout.paidTicketContractAddress).burnTicketsBeforeRefund(
                _naffleId,
                _paidTicketIds,
                _owner
            );
            (bool success, ) = _owner.call{value: _paidTicketIds.length * naffle.ticketPriceInWei}("");
            if (!success) {
                revert UnableToSendFunds();
            }
        }
    }

    /**
     * @dev burns open entry tickets and mints new open entry tickets
     * @dev number of paid tickets required to redeem one open entry ticket is also based on whether or not the user has staked a founders key, and if so, for how long
     * 
     * Concern: truncation at small quantities
     */    
    function _redeemOpenEntryTickets(uint256 _naffleId, uint256[] memory _paidTicketIds, address _owner) internal {

        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();

        //should be initialized in L2NaffleDiamond/L2NaffleAdmin
        uint256 paidToOpenEntryRedeemExchangeRate = layout.paidToOpenEntryRedeemExchangeRate;
        uint256 length = _paidTicketIds.length;

        //get best staked founders key, see how long it was staked, assign multiplier accordingly
        uint256 bestStakingDuration;
        uint256 stakingDuration;
        for(uint256 i = 0; i < layout.userToStakedFoundersKeyAmount[_owner]; ++i) {
            stakingDuration = layout.userToStakedFoundersKeyIdsToStakeDuration[_owner][i];
            if (stakingDuration > bestStakingDuration) {
                bestStakingDuration = stakingDuration;
            }
        }

        /**
            Example: User staked an omni key for 1 month --> 1.25x multiplier here means that in order
            to avoid truncation issues, the base exchange rate should be 100 paid tickets to 1 open entry ticket.
            The staked user in this case would have an exchange rate of 100/1.25 or 80 paid tickets to 1 open entry ticket
         */
        uint256 stakedFoundersKeyRedeemMultiplier = 1;
        if(bestStakingDuration == SECONDS_IN_ONE_MONTH) stakedFoundersKeyRedeemMultiplier = layout.stakingMultipliersForOETicketRedeem[0];
        else if(bestStakingDuration == SECONDS_IN_THREE_MONTHS) stakedFoundersKeyRedeemMultiplier = layout.stakingMultipliersForOETicketRedeem[1];
        else if(bestStakingDuration == SECONDS_IN_SIX_MONTHS) stakedFoundersKeyRedeemMultiplier = layout.stakingMultipliersForOETicketRedeem[2];
        else if (bestStakingDuration == SECONDS_IN_TWELVE_MONTHS) stakedFoundersKeyRedeemMultiplier = layout.stakingMultipliersForOETicketRedeem[3];

        // Ex: base == 100, multiplier == 1.25x --> 100 * 10000 / 12500 = 80
        uint256 thisPaidToOpenEntryRedeemExchangeRate = (paidToOpenEntryRedeemExchangeRate * NUMERATOR) / stakedFoundersKeyRedeemMultiplier;

        //ensure number of paid ticket IDs supplied is divisible w no remainder by the paidToOpenEntryRedeemExchangeRate
        if (length % paidToOpenEntryRedeemExchangeRate  != 0) {
            revert InvalidPaidToOpenEntryRatio(length, paidToOpenEntryRedeemExchangeRate);
        }

        //assign the amount to mint based on base exchange rate and multiplier
        uint256 openEntryTicketQuantityToMint = length / paidToOpenEntryRedeemExchangeRate;

        //burn used paid tickets - this confirms naffle is finished, and that the tokens are owned by the user and connected to the supplied naffleId
        IL2PaidTicketBase(layout.paidTicketContractAddress).burnUsedPaidTicketsBeforeRedeemingOpenEntryTickets(
            _naffleId,
            _paidTicketIds,
            _owner
        );

        //mint new open entry tickets to _owner
        IL2OpenEntryTicketBase(layout.openEntryTicketContractAddress).mintUponRedeemingPaidTickets(
            _owner,
            openEntryTicketQuantityToMint
        );

        //TODO: check protocol invariants 

        emit OpenEntryTicketsRedeemedWithUsedPaidTickets(
            _naffleId,
            _paidTicketIds,
            _owner,
            openEntryTicketQuantityToMint
        );

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

        if (naffle.ethTokenAddress == address(0)) {
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

    //=============================================================================
    // ADMIN RELATED
    // _withdrawPlatformFees
    //=============================================================================
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

    //=============================================================================
    // GETTERS AND SETTERS - BOTH ADMIN AND PUBLIC
    // _getAdminRole
    // _getPlatformFee
    // _setPlatformFee
    // _getOpenEntryRatio
    // _setOpenEntryRatio
    // _getL1NaffleContractAddress
    // _setL1NaffleContractAddress
    // _getNaffleById
    // _setPaidTicketContractAddress
    // _getPaidTicketContractAddress
    // _setOpenEntryTicketContractAddress
    // _getOpenEntryTicketContractAddress
    // _setL1MessengerContractAddress
    // _setMaxPostponeTime
    // _getMaxPostponeTime
    // _setPaidToOpenEntryRedeemExchangeRate
    // _setL1StakingContractAddress
    // _getL1StakingContractAddress
    //=============================================================================
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
     * @notice sets the number of paid tickets one needs to burn to redeem an open entry ticket
     */
    function _setPaidToOpenEntryRedeemExchangeRate(uint256 _paidToOpenEntryRedeemExchangeRate) internal {
        L2NaffleBaseStorage.layout().paidToOpenEntryRedeemExchangeRate = _paidToOpenEntryRedeemExchangeRate;
    }

    /**
     * @notice stores staking data from the L1 staking contract for purposes of calculating exchange rate when redeeming used paid for open entry tickets
     * @dev deletes data if _user, _tokenId, _stakeDuration are all 0 (used to clear data when a user unstakes)
     * @dev adds to staking balance if setting non-zero values, subtracts if deleting a record
     */
    function _setUserToStakedFoundersKeyIdsToStakeDuration(address _user, uint256 _tokenId, uint256 _stakeDuration) internal {
        L2NaffleBaseStorage.Layout storage layout = L2NaffleBaseStorage.layout();
        if(_stakeDuration == 0) {
            delete layout.userToStakedFoundersKeyIdsToStakeDuration[_user][_tokenId];
            --layout.userToStakedFoundersKeyAmount[_user];
        } else {
            layout.userToStakedFoundersKeyIdsToStakeDuration[_user][_tokenId] = _stakeDuration;
            ++layout.userToStakedFoundersKeyAmount[_user];
        }
    }

    /**
     * @notice sets L1 staking contract address
     */
    function _setL1StakingContractAddress(address _l1StakingContractAddress) internal returns (address l1StakingContractAddress) {
        L2NaffleBaseStorage.layout().l1StakingContractAddress = _l1StakingContractAddress;
    }

    /**
     * @notice gets  L1 staking contract address
     */
    function _getL1StakingContractAddress() internal view returns (address l1StakingContractAddress) {
        l1StakingContractAddress = L2NaffleBaseStorage.layout().l1StakingContractAddress;
    }

    /**
     * @notice sets multipliers for each of 1/3/6/12 months staking period for exchange rate between used paid tickets and OE tickets
     */
    function _setStakingMultipliersForOETicketRedeem(uint256[] memory _multipliers) internal {
        L2NaffleBaseStorage.layout().stakingMultipliersForOETicketRedeem = _multipliers;
    }
}
