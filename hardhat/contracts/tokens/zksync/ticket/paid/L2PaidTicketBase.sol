// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketBaseInternal.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBase.sol";
import "@solidstate/contracts/token/ERC721/SolidStateERC721.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";

contract L2PaidTicketBase is IL2PaidTicketBase, L2PaidTicketBaseInternal, SolidStateERC721, AccessControl {
    modifier onlyL2NaffleContract() {
        if (msg.sender != _getL2NaffleContractAddress()) {
            revert NotAllowed();
        }
        _;
    }

    /**
     * @inheritdoc IL2PaidTicketBase
     */
    function mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 ticketPriceInWei, uint256 startingTicketId) external onlyL2NaffleContract returns (uint256[] memory ticketIds) {
        _mintTickets(_to, _amount, _naffleId, ticketPriceInWei, startingTicketId);
    }

    /**
     * @inheritdoc IL2PaidTicketBase
     */
    function refundAndBurnTicket(uint256 _naffleId, uint256 _naffleTicketId) external {
        _refundAndBurnTicket(_naffleId, _naffleTicketId);
    }

    /**
     * @inheritdoc SolidStateERC721
     */
    function _handleApproveMessageValue(
        address operator,
        uint256 tokenId,
        uint256 value
    ) internal virtual override(SolidStateERC721, ERC721BaseInternal) {
        super._handleApproveMessageValue(operator, tokenId, value);
    }

    /**
     * @inheritdoc SolidStateERC721
     */
    function _handleTransferMessageValue(
        address from,
        address to,
        uint256 tokenId,
        uint256 value
    ) internal virtual override(SolidStateERC721, ERC721BaseInternal) {
        super._handleTransferMessageValue(from, to, tokenId, value);
    }

    /**
     * @inheritdoc SolidStateERC721
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721BaseInternal, SolidStateERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
