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

    /**
     * @inheritdoc IL2OpenEntryTicketBase
     */
    function detachFromNaffle(uint256 _naffleId, uint256[] memory _naffleTicketIds) external onlyL2NaffleContract {
        _detachFromNaffle(_naffleId, _naffleTicketIds);
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

    /**
     * @inheritdoc IL2OpenEntryTicketBase
     */
    function attachToNaffle(uint256 _naffleId, uint256[] memory _ticketIds, uint256 startingTicketId, address owner) external onlyL2NaffleContract() {
        _attachToNaffle(_naffleId, _ticketIds, startingTicketId, owner);
    }

    /**
     * @inheritdoc IL2OpenEntryTicketBase
     */
    function mintOpenEntryTicketsForUser(address _to, uint256 _amount) external override onlyL2NaffleContract() {
        _adminMint(_to, _amount);
    }
    
    /**
     * @inheritdoc IL2OpenEntryTicketBase
     */
    function claimStakingReward(
        uint256 _amount,
        uint256 _totalClaimed,
        bytes _signature,
     ) external {
        _claimStakingReward (
            _amount,
            _totalClaimed,
            _signature
        )
     }
}
