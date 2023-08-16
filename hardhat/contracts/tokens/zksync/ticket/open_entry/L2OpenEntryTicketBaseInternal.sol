// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2OpenEntryTicketStorage.sol";

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";
import "../../../../../interfaces/naffle/zksync/IL2NaffleView.sol";
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBaseInternal.sol";
import "@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol";

abstract contract L2OpenEntryTicketBaseInternal is IL2OpenEntryTicketBaseInternal, AccessControlInternal, ERC721BaseInternal, ERC721EnumerableInternal {

    /**
     * @notice attaches tickets to a naffle.
     * @dev if the naffle id on the ticket is not 0 a TicketAlreadyUsed error is thrown.
     * @dev if the owner of the ticket is not owner provided a NotOwnerOfTicket error is thrown.
     * @param _naffleId the id of the naffle.
     * @param _ticketIds the ids of the tickets to attach.
     * @param startingTicketId the starting ticket id on the naffle.
     * @param owner the owner of the tickets.
     */
    function _attachToNaffle(uint256 _naffleId, uint256[] memory _ticketIds, uint256 startingTicketId, address owner) internal {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();

        for (uint256 i = 0; i < _ticketIds.length; i++) {
            uint256 ticketId = _ticketIds[i];
            NaffleTypes.OpenEntryTicket storage ticket = l.openEntryTickets[ticketId];

            if (ticket.naffleId != 0) {
                revert TicketAlreadyUsed(ticketId);
            }
            if (_ownerOf(ticketId) != owner) {
                revert NotOwnerOfTicket(ticketId);
            }

            ticket.naffleId = _naffleId;
            ticket.ticketIdOnNaffle = startingTicketId;
            l.naffleIdTicketIdOnNaffleTicketId[_naffleId][startingTicketId] = ticketId;
            ++startingTicketId;
        }

        emit TicketsAttachedToNaffle(_naffleId, _ticketIds, startingTicketId, owner);
    }

    /**
     * @notice detaches tickets from a naffle.
     * @dev if the naffle status is not cancelled a NaffleNotCancelled error is thrown.
     * @dev if the ticket is not found a InvalidTicketId error is thrown.
     * @dev if the owner of the ticket is not the msg.sender a NotOwnerOfTicket error is thrown.
     * @param _naffleId the id of the naffle.
     * @param _ticketIdsOnNaffle the id of the ticket on the naffle.
     */
    function _detachFromNaffle(uint256 _naffleId, uint256[] memory _ticketIdsOnNaffle) internal {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();
        NaffleTypes.L2Naffle memory naffle = IL2NaffleView(_getL2NaffleContractAddress()).getNaffleById(_naffleId);

        if (naffle.status != NaffleTypes.NaffleStatus.CANCELLED) {
            revert NaffleNotCancelled(naffle.status);
        }

        uint256 length = _ticketIdsOnNaffle.length;
        uint256[] memory totalTicketIds = new uint256[](length);


        for (uint i = 0; i < length; ++i) {
            uint256 ticketId = l.naffleIdTicketIdOnNaffleTicketId[_naffleId][_ticketIdsOnNaffle[i]];
            NaffleTypes.OpenEntryTicket storage ticket = l.openEntryTickets[ticketId];

            if (ticketId == 0) {
                revert InvalidTicketId(_ticketIdsOnNaffle[i]);
            }

            ticket.naffleId = 0;
            ticket.ticketIdOnNaffle = 0;
            totalTicketIds[i] = ticketId;
        }

        emit TicketsDetachedFromNaffle(_naffleId, totalTicketIds, _ticketIdsOnNaffle);
    }

    /**
     * @notice returns the owner of a ticket on a naffle.
     * @param _naffleId the id of the naffle.
     * @param _ticketIdOnNaffle the id of the ticket on the naffle.
     * @return owner the owner of the ticket.
     */
    function _getOwnerOfNaffleTicketId(uint256 _naffleId, uint256 _ticketIdOnNaffle) internal view returns (address owner) {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();

        uint256 totalTicketId = l.naffleIdTicketIdOnNaffleTicketId[_naffleId][_ticketIdOnNaffle];
        return _ownerOf(totalTicketId);
    }

    /**
     * @notice get the admin role.
     * @return adminRole the admin role.
     */
    function _getAdminRole() internal pure returns (bytes32 adminRole) {
        adminRole = AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    /**
     * @notice gets the l2 naffle contract address
     * @return l2NaffleContractAddress the l2 naffle contract address.
     */
    function _getL2NaffleContractAddress() internal view returns (address l2NaffleContractAddress) {
        l2NaffleContractAddress = L2OpenEntryTicketStorage.layout().l2NaffleContractAddress;
    }

    /**
     * @notice sets the l2 naffle contract address.
     * @param _l2NaffleContractAddress the l2 naffle contract address.
     */
    function _setL2NaffleContractAddress(address _l2NaffleContractAddress) internal {
        L2OpenEntryTicketStorage.layout().l2NaffleContractAddress = _l2NaffleContractAddress;
    }

    /**
     * @notice gets the total supply.
     * @return totalSupply the total supply.
     */
    function _getTotalSupply() internal view returns (uint256 totalSupply) {
        totalSupply = _totalSupply();
    }

    /**
     * @notice sets the base URI
     * @param _baseURI the base URI.
     */
    function _setBaseURI(string memory _baseURI) internal {
        ERC721MetadataStorage.layout().baseURI = _baseURI;
    }

    /**
     * @notice gets open entry ticket by its id
     * @param _ticketId the id of the ticket.
     * @return ticket the open entry ticket.
     */
    function _getOpenEntryTicketById(uint256 _ticketId) internal view returns (NaffleTypes.OpenEntryTicket memory ticket) {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();
        ticket = l.openEntryTickets[_ticketId];
    }

    /**
     * @notice mints tickets.
     * @param _to the address to mint the tickets to.
     * @param _amount the amount of tickets to mint.
     */
    function _adminMint(address _to, uint256 _amount) internal {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();
        for (uint256 i = 0; i < _amount; i++) {
            l.totalMinted++;
            _mint(_to, l.totalMinted);
            NaffleTypes.OpenEntryTicket memory ticket = NaffleTypes.OpenEntryTicket(0, 0, false);
            L2OpenEntryTicketStorage.layout().openEntryTickets[l.totalMinted] = ticket;
        }
    }
}
