// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2OpenEntryTicketStorage.sol";

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";
import "@solidstate/contracts/token/ERC721/metadata/ERC721MetadataInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBaseInternal.sol";


abstract contract L2OpenEntryTicketBaseInternal is IL2OpenEntryTicketBaseInternal, AccessControlInternal, ERC721BaseInternal, ERC721EnumerableInternal, ERC721MetadataInternal{
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
            ++startingTicketId;
        }
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getL2NaffleContractAddress() internal view returns (address) {
        return L2OpenEntryTicketStorage.layout().l2NaffleContractAddress;
    }

    function _setL2NaffleContractAddress(address _l2NaffleContractAddress) internal {
        L2OpenEntryTicketStorage.layout().l2NaffleContractAddress = _l2NaffleContractAddress;
    }

    function _setBaseURI(string memory _baseURI) internal {
        ERC721MetadataStorage.layout().baseURI = _baseURI;
    }

    function _getTotalSupply() internal view returns (uint256) {
        return _totalSupply();
    }

    function _getOpenEntryTicketById(uint256 _ticketId) internal view returns (NaffleTypes.OpenEntryTicket memory) {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();
        return l.openEntryTickets[_ticketId];
    }

    function _adminMint(address _to, uint256 _amount) internal {
        for (uint256 i = 0; i < _amount; i++) {
            uint256 ticketId = _totalSupply() + 1;
            _mint(_to, ticketId);
            NaffleTypes.OpenEntryTicket memory ticket = NaffleTypes.OpenEntryTicket(0, 0, false);
            L2OpenEntryTicketStorage.layout().openEntryTickets[ticketId] = ticket;
        }
    }


    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721BaseInternal, ERC721MetadataInternal) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
