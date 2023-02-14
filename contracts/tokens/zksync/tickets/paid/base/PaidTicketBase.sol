// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IPaidTicketBase } from "../../../../../../interfaces/tokens/zksync/tickets/paid/base/IPaidTicketBase.sol";
import { AccessControl } from "@solidstate/contracts/access/access_control/AccessControl.sol";
import { SolidStateERC721 } from '@solidstate/contracts/token/ERC721/SolidStateERC721.sol';
import { PaidTicketBaseInternal } from "./PaidTicketBaseInternal.sol";
import { ERC721BaseInternal } from '@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol';
import { Ownable } from "@solidstate/contracts/access/ownable/Ownable.sol";


contract PaidTicketBase is Ownable, AccessControl, SolidStateERC721, PaidTicketBaseInternal, IPaidTicketBase {
    function initialize(address _naffleContract, address _admin) external {
        _setNaffleContract(_naffleContract);
        _grantRole(_getAdminRole(), _admin);
        _setOwner(_admin);
    }

    function mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 _ticketPriceInWei) external payable returns (uint256[] memory) {
        _mintTickets(_to, _amount, _naffleId, _ticketPriceInWei);
    }

    function setNaffleContract(address _naffleContract) external onlyRole(_getAdminRole()) {
        _setNaffleContract(_naffleContract);
    }

    function owner() external view returns (address) {
        return _owner();
    }

    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
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

    function _setApprovalForAll(
        address operator,
        bool approved
    )
        internal
        override(ERC721BaseInternal)
    {
        super._setApprovalForAll(operator, approved);
    }

    function _approve(
        address operator,
        uint256 tokenId
    )
        internal
        override(ERC721BaseInternal)
    {
        super._approve(operator, tokenId);
    }

    function _transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721BaseInternal) {
        super._transferFrom(from, to, tokenId);
    }

    function _safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721BaseInternal){
        super._safeTransferFrom(from, to, tokenId);
    }

    function _safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal override(ERC721BaseInternal) {
        super._safeTransferFrom(from, to, tokenId, data);
    }
}

