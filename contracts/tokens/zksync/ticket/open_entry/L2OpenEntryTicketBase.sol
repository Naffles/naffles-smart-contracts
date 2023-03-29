// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2OpenEntryTicketBaseInternal.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/token/ERC721/SolidStateERC721.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBase.sol";

contract L2OpenEntryTicketBase is IL2OpenEntryTicketBase, L2OpenEntryTicketBaseInternal, SolidStateERC721, AccessControl {
     modifier onlyL2NaffleContract() {
        if (msg.sender != _getL2NaffleContractAddress()) {
            revert NotAllowed();
        }
        _;
    }

    function detachFromNaffle(uint256 _naffleId, uint256 _naffleTicketId) external {
        _detachFromNaffle(_naffleId, _naffleTicketId);
    }

    function adminMint(address _to, uint256 _amount) external onlyRole(_getAdminRole()){
        for (uint256 i = 0; i < _amount; i++) {
            uint256 ticketId = _totalSupply() + 1;
            _mint(_to, ticketId);
            NaffleTypes.OpenEntryTicket memory ticket = NaffleTypes.OpenEntryTicket(0, 0, false);
            L2OpenEntryTicketStorage.layout().openEntryTickets[ticketId] = ticket;
        }
    }

    function _handleApproveMessageValue(
        address operator,
        uint256 tokenId,
        uint256 value
    ) internal virtual override(SolidStateERC721, ERC721BaseInternal) {
        super._handleApproveMessageValue(operator, tokenId, value);
    }

    function _handleTransferMessageValue(
        address from,
        address to,
        uint256 tokenId,
        uint256 value
    ) internal virtual override(SolidStateERC721, ERC721BaseInternal) {
        super._handleTransferMessageValue(from, to, tokenId, value);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721BaseInternal, SolidStateERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function attachToNaffle(uint256 _naffleId, uint256[] memory _ticketIds, uint256 startingTicketId, address owner) external onlyL2NaffleContract() {
        _attachToNaffle(_naffleId, _ticketIds, startingTicketId, owner);
    }
}
