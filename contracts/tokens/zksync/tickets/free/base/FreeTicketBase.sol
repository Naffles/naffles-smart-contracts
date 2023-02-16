// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IFreeTicketBase} from "../../../../../../interfaces/tokens/zksync/tickets/Free/base/IFreeTicketBase.sol";
import {AccessControl} from "@solidstate/contracts/access/access_control/AccessControl.sol";
import {SolidStateERC721} from "@solidstate/contracts/token/ERC721/SolidStateERC721.sol";
import {FreeTicketBaseInternal} from "./FreeTicketBaseInternal.sol";
import {ERC721BaseInternal} from "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import {Ownable} from "@solidstate/contracts/access/ownable/Ownable.sol";

contract FreeTicketBase is
    Ownable,
    AccessControl,
    SolidStateERC721,
    FreeTicketBaseInternal,
    IFreeTicketBase
{
    constructor(address _admin) {
        _grantRole(_getAdminRole(), _admin);
        _setOwner(_admin);
    }

    function mintTickets(
        address _to,
        uint256 _amount,
        uint256 _naffleId,
        uint256 _ticketPriceInWei
    ) external onlyRole(_getNaffleContractRole()) returns (uint256[] memory) {
        _mintTickets(_to, _amount, _naffleId, _ticketPriceInWei);
    }

    function setNaffleContract(
        address _naffleContract
    ) external onlyRole(_getAdminRole()) {
        _setNaffleContract(_naffleContract);
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

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721BaseInternal, SolidStateERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
