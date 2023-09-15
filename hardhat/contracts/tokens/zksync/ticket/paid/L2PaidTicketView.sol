// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;


import "./L2PaidTicketBaseInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketView.sol";

contract L2PaidTicketView is IL2PaidTicketView, L2PaidTicketBaseInternal {
    /**
     * @inheritdoc IL2PaidTicketView
     */
    function getL2NaffleContractAddress() external view returns (address) {
        return _getL2NaffleContractAddress();
    }

    /**
     * @inheritdoc IL2PaidTicketView
     */
    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }

    /**
     * @inheritdoc IL2PaidTicketView
     */
    function getTicketById(uint256 _ticketId) external view returns (NaffleTypes.PaidTicket memory) {
        return _getTicketById(_ticketId);
    }

    /**
     * @inheritdoc IL2PaidTicketView
     */
    function getTicketByIdOnNaffle(uint256 _ticketIdOnNaffle, uint256 _naffleId) external view returns (NaffleTypes.PaidTicket memory) {
        return _getTicketByIdOnNaffle(_ticketIdOnNaffle, _naffleId);
    }

    /**
     * @inheritdoc IL2PaidTicketView
     */
    function getTotalSupply() external view returns (uint256) {
        return _totalSupply();
    }

    /**
     * @inheritdoc IL2PaidTicketView
     */
    function getOwnerOfNaffleTicketId(uint256 _naffleId, uint256 _ticketIdOnNaffle) external view returns (address) {
        return _getOwnerOfNaffleTicketId(_naffleId, _ticketIdOnNaffle);
    }
}