// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBaseInternal.sol";
import "@solidstate/contracts/interfaces/IERC1155.sol";
import "@solidstate/contracts/token/ERC1155/base/ERC1155BaseInternal.sol";
import "@solidstate/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol";
import "@solidstate/contracts/token/ERC1155/metadata/ERC1155MetadataStorage.sol";
import "../../../../../interfaces/naffle/zksync/IL2NaffleView.sol";
import "../../../../libraries/NaffleTypes.sol";


abstract contract L2PaidTicketBaseInternal is IL2PaidTicketBaseInternal, AccessControlInternal, ERC1155BaseInternal, ERC1155EnumerableInternal {

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
                owner: _to,
                ticketIdOnNaffle: ticketIdOnNaffle,
                ticketPriceInWei: _ticketPriceInWei,
                naffleId: _naffleId,
                winningTicket: false
            });

            l.totalMinted++;
            totalTicketId = l.totalMinted;
            l.naffleIdNaffleTicketIdTicketId[_naffleId][ticketIdOnNaffle] = totalTicketId;
            l.paidTickets[totalTicketId] = paidTicket;
            ticketIds[i] = totalTicketId;
        }

        _safeMintBatch(_to, _naffleId, _amount, "");

        emit PaidTicketsMinted(_to, ticketIds, _naffleId, _ticketPriceInWei, startingTicketId);
        return ticketIds;
    }

    /**
     * @notice refunds tickets and burns them.
     * @dev if the status of the naffle is not cancelled a NaffleNotCancelled error is thrown.
     * @dev if the ticket id is invalid an InvalidTicketId error is thrown.
     * @dev if the msg.sender is not the owner of the ticket a NotTicketOwner error is thrown.
     * @dev if the refund fails a RefundFailed error is thrown.
     * @param _naffleId the id of the naffle.
     * @param _naffleTicketIds the id of the ticket on the naffle.
     * @param _owner the owner of the tickets.
     */
    function _refundAndBurnTickets(uint256 _naffleId, uint256[] memory _naffleTicketIds, address _owner) internal {
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

            if (_owner != l.paidTickets[ticketId].owner) {
                revert NotTicketOwner(_owner);
            }

            delete l.naffleIdNaffleTicketIdTicketId[_naffleId][_naffleTicketIds[i]];
            NaffleTypes.PaidTicket storage paidTicket = l.paidTickets[ticketId];

            // We reset the naffle id so we know this is refunded because we can't delete custom structs.
            paidTicket.ticketPriceInWei = 0;
            paidTicket.naffleId = 0;
            paidTicket.ticketIdOnNaffle = 0;

            totalTicketIds[i] = ticketId;
        }

        _burnBatch(_owner, _naffleId, _naffleTicketIds.length);

        emit PaidTicketsRefundedAndBurned(_owner, _naffleId, totalTicketIds, _naffleTicketIds);
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
        ERC1155MetadataStorage.layout().baseURI = _baseURI;
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
