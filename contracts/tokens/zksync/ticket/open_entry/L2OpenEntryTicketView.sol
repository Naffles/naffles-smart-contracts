// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketView.sol";
import "./L2OpenEntryTicketBaseInternal.sol";


contract L2OpenEntryTicketView is IL2OpenEntryTicketView, L2OpenEntryTicketBaseInternal {
    function getL2NaffleContractAddress() external view returns (address) {
        return _getL2NaffleContractAddress();
    }

    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }

    function getTotalSupply() external view returns (uint256) {
        return _getTotalSupply();
    }

    function getOpenEntryTicketById(uint256 _ticketId) external view returns (NaffleTypes.OpenEntryTicket memory) {
        return _getOpenEntryTicketById(_ticketId);
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        return _tokenURI(_tokenId);
    }
}