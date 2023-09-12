// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBaseInternal.sol";
import "@solidstate/contracts/interfaces/IERC721.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";
import "@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol";
import "../../../../../interfaces/naffle/zksync/IL2NaffleView.sol";
import "../../../../libraries/NaffleTypes.sol";


abstract contract L2PaidTicketBaseInternal is IL2PaidTicketBaseInternal, AccessControlInternal, ERC721BaseInternal, ERC721EnumerableInternal {

    /**
     * @notice mints tickets to an address for a specific naffle.
     * @param _to the address to mint the tickets to.
     * @param _amount the amount of tickets to mint.
     * @param _naffleId the id of the naffle.
     * @param _ticketPriceInWei the price of the ticket in wei.
     * @param startingTicketId the starting ticket id on the naffle.
     * @return ticketIds the ids of the tickets minted.
     */
    function _mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 _ticketPriceInWei, uint256 startingTicketId) internal returns(uint256[] memory) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        uint256[] memory ticketIds = new uint256[](_amount);
        uint256 totalTicketId;

        for (uint256 i = 0; i < _amount; i++) {
            uint256 ticketIdOnNaffle = startingTicketId + i;
            NaffleTypes.PaidTicket memory paidTicket = NaffleTypes.PaidTicket({
                ticketIdOnNaffle: ticketIdOnNaffle,
                ticketPriceInWei: _ticketPriceInWei,
                naffleId: _naffleId,
                winningTicket: false
            });
            l.totalMinted++;
            totalTicketId = l.totalMinted;
            _mint(_to, totalTicketId);
            l.naffleIdNaffleTicketIdTicketId[_naffleId][ticketIdOnNaffle] = totalTicketId;
            l.paidTickets[totalTicketId] = paidTicket;
            ticketIds[i] = totalTicketId;
        }

        emit PaidTicketsMinted(_to, ticketIds, _naffleId, _ticketPriceInWei, startingTicketId);
        return ticketIds;
    }

    /**
     * @notice burns tickets before theyre refunded in the L2Naffle contract
     * @dev if the status of the naffle is not cancelled a NaffleNotCancelled error is thrown.
     * @dev if the ticket id is invalid an InvalidTicketId error is thrown.
     * @dev if the msg.sender is not the owner of the ticket a NotTicketOwner error is thrown.
     * @param _naffleId the id of the naffle.
     * @param _naffleTicketIds the id of the ticket on the naffle.
     * @param _owner the owner of the tickets.
     */
    function _burnTicketsBeforeRefund(uint256 _naffleId, uint256[] memory _naffleTicketIds, address _owner) internal {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        NaffleTypes.L2Naffle memory naffle = IL2NaffleView(_getL2NaffleContractAddress()).getNaffleById(_naffleId);

        if (naffle.status != NaffleTypes.NaffleStatus.CANCELLED) {
            revert NaffleNotCancelled(naffle.status);
        }

        uint256 length = _naffleTicketIds.length;
        uint256[] memory totalTicketIds = new uint256[](length);

        if (length == 0) {
            return;
        }

        for (uint i = 0; i < length; ++i) {
            uint256 ticketId = l.naffleIdNaffleTicketIdTicketId[_naffleId][_naffleTicketIds[i]];

            if (_owner != _ownerOf(ticketId)) {
                revert NotTicketOwner(_owner);
            }
            _burn(ticketId);

            delete l.naffleIdNaffleTicketIdTicketId[_naffleId][_naffleTicketIds[i]];
            NaffleTypes.PaidTicket storage paidTicket = l.paidTickets[ticketId];

            // We reset the naffle id so we know this is refunded because we can't delete custom structs.
            paidTicket.ticketPriceInWei = 0;
            paidTicket.naffleId = 0;
            paidTicket.ticketIdOnNaffle = 0;

            totalTicketIds[i] = ticketId;
        }

        emit PaidTicketsRefundedAndBurned(_owner, _naffleId, totalTicketIds, _naffleTicketIds);
    }

    /** [ in development - curion addition Sep 12 2023]
     * @notice refeems used paid tickets for open entry tickets according to a stored ratio of paid tickets to open entry tickets.
     * @dev if length of input array is not divisible by paidToOpenEntryRedeemRatio a InvalidPaidToOpenEntryRatio error is thrown.
     * @dev no need to change any storage since the naffle is already over, as opposed to above where the ticket is refunded
     */
    function _burnUsedPaidTicketsBeforeRedeemingOpenEntryTickets(uint256 _naffleId, uint256[] memory _naffleTicketIds, address _owner) internal {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        NaffleTypes.L2Naffle memory naffle = IL2NaffleView(_getL2NaffleContractAddress()).getNaffleById(_naffleId);
        uint256 length = _naffleTicketIds.length;

        //check that naffle is over
        if (naffle.status != NaffleTypes.NaffleStatus.FINISHED) {
            revert NaffleNotFinished(_naffleId);
        }

        //iterate over length and burn the paid tickets
        for (uint256 i = 0; i < length; i++) {
            uint256 ticketId = l.naffleIdNaffleTicketIdTicketId[_naffleId][_naffleTicketIds[i]];

            //check that ticket belongs to naffle - possibly redundant since the owner check will fail if there is an ticket/naffle ID mismatch
            if (l.paidTickets[ticketId].naffleId != _naffleId) {
                revert InvalidTicketId(ticketId);
            }
            
            if (_owner != _ownerOf(ticketId)) {
                revert NotTicketOwner(_owner);
            }

            _burn(ticketId);
        }

        //mint open entry tickets according to ratio -- in naffle contract
    }

    /**
     * @notice gets the owner of a ticket by its id on the naffle.
     * @param _naffleId the id of the naffle.
     * @param _ticketIdOnNaffle the id of the ticket on the naffle.
     * @return owner the owner of the ticket.
     */
    function _getOwnerOfNaffleTicketId(uint256 _naffleId, uint256 _ticketIdOnNaffle) internal view returns (address owner) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        owner = _ownerOf(l.naffleIdNaffleTicketIdTicketId[_naffleId][_ticketIdOnNaffle]);
    }

    /**
     * @notice gets the admin role/
     * @return adminRole the admin role.
     */
    function _getAdminRole() internal pure returns (bytes32 adminRole) {
        adminRole = AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    /**
     * @notice gets the L2 naffle contract address.
     * @return l2NaffleContractAddress the L2 naffle contract address.
     */
    function _getL2NaffleContractAddress() internal view returns (address l2NaffleContractAddress) {
        l2NaffleContractAddress = L2PaidTicketStorage.layout().l2NaffleContractAddress;
    }

    /**
     * @notice sets the L2 naffle contract address.
     * @param _l2NaffleContractAddress the L2 naffle contract address.
     */

    function _setL2NaffleContractAddress(address _l2NaffleContractAddress) internal {
        L2PaidTicketStorage.layout().l2NaffleContractAddress = _l2NaffleContractAddress;
    }

    /**
     * @notice sets the base URI.
     * @param _baseURI the base URI.
     */
    function _setBaseURI(string memory _baseURI) internal {
        ERC721MetadataStorage.layout().baseURI = _baseURI;
    }

    /**
     * @notice gets the ticket by its id on the naffle.
     * @param _ticketIdOnNaffle the id of the ticket on the naffle.
     * @param _naffleId the id of the naffle.
     * @return ticket the ticket.
     */
    function _getTicketByIdOnNaffle(uint256 _ticketIdOnNaffle, uint256 _naffleId) internal view returns (NaffleTypes.PaidTicket memory ticket) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        ticket = l.paidTickets[l.naffleIdNaffleTicketIdTicketId[_naffleId][_ticketIdOnNaffle]];
    }

    /**
     * @notice gets the ticket by its id.
     * @param _ticketId the id of the ticket.
     * @return ticket the ticket.
     */
    function _getTicketById(uint256 _ticketId) internal view returns (NaffleTypes.PaidTicket memory ticket) {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        ticket = l.paidTickets[_ticketId];
    }
}
