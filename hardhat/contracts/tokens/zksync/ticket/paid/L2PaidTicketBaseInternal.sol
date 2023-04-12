// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketStorage.sol";

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBaseInternal.sol";
import "@solidstate/contracts/interfaces/IERC721.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";
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
            totalTicketId = _totalSupply() + 1;
            _mint(_to, totalTicketId);
            l.naffleIdNaffleTicketIdTicketId[_naffleId][ticketIdOnNaffle] = totalTicketId;
            l.paidTickets[totalTicketId] = paidTicket;
            ticketIds[i] = ticketIdOnNaffle;
        }

        emit PaidTicketsMinted(_to, ticketIds, _naffleId, _ticketPriceInWei, startingTicketId);
        return ticketIds;
    }

    /**
     * @notice refunds a ticket and burns it.
     * @dev if the status of the naffle is not cancelled a NaffleNotCancelled error is thrown.
     * @dev if the ticket id is invalid an InvalidTicketId error is thrown.
     * @dev if the msg.sender is not the owner of the ticket a NotTicketOwner error is thrown.
     * @dev if the refund fails a RefundFailed error is thrown.
     * @param _naffleId the id of the naffle.
     * @param _naffleTicketId the id of the ticket on the naffle.
     */
    function _refundAndBurnTicket(uint256 _naffleId, uint256 _naffleTicketId) internal {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        NaffleTypes.L2Naffle memory naffle = IL2NaffleView(_getL2NaffleContractAddress()).getNaffleById(_naffleId);

        if (naffle.status != NaffleTypes.NaffleStatus.CANCELLED) {
            revert NaffleNotCancelled(naffle.status);
        }

        uint256 totalTicketId = l.naffleIdNaffleTicketIdTicketId[_naffleId][_naffleTicketId];
        if (totalTicketId == 0) {
            revert InvalidTicketId(_naffleTicketId);
        }

        delete l.naffleIdNaffleTicketIdTicketId[_naffleId][_naffleTicketId];
        NaffleTypes.PaidTicket storage paidTicket = l.paidTickets[totalTicketId];

        address owner = _ownerOf(totalTicketId);
        if (owner != msg.sender) {
            revert NotTicketOwner(msg.sender);
        }

        (bool success, ) = owner.call{value: paidTicket.ticketPriceInWei}("");
        if (!success) {
            revert RefundFailed();
        }

        // We reset the naffle id so we know this is refunded because we can't delete custom structs.
        paidTicket.naffleId = 0;
        paidTicket.ticketIdOnNaffle = 0;
        _burn(totalTicketId);

        emit PaidTicketRefundedAndBurned(owner, _naffleId, totalTicketId, _naffleTicketId);
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
