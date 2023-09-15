// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "./L1NaffleBaseInternal.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleView.sol";

contract L1NaffleView is IL1NaffleView, L1NaffleBaseInternal {
    /**
     * @inheritdoc IL1NaffleView
     */
    function getMinimumNaffleDuration() external view returns (uint256) {
        return _getMinimumNaffleDuration();
    }

    /**
     * @inheritdoc IL1NaffleView
     */
    function getMinimumPaidTicketSpots() external view returns (uint256) {
        return _getMinimumPaidTicketSpots();
    }

    /**
     * @inheritdoc IL1NaffleView
     */
    function getMinimumPaidTicketPriceInWei() external view returns (uint256) {
        return _getMinimumPaidTicketPriceInWei();
    }

    /**
     * @inheritdoc IL1NaffleView
     */
    function getZkSyncNaffleContractAddress() external view returns (address) {
        return _getZkSyncNaffleContractAddress();
    }

    /**
     * @inheritdoc IL1NaffleView
     */
    function getZkSyncAddress() external view returns (address) {
        return _getZkSyncAddress();
    }

    /**
     * @inheritdoc IL1NaffleView
     */
    function getFoundersKeyAddress() external view returns (address) {
        return _getFoundersKeyAddress();
    }

    /**
     * @inheritdoc IL1NaffleView
     */
    function getFoundersKeyPlaceholderAddress() external view returns (address) {
        return _getFoundersKeyPlaceholderAddress();
    }

    /**
     * @inheritdoc IL1NaffleView
     */
    function getAdminRole() external view returns (bytes32) {
        return _getAdminRole();
    }

    /**
     * @inheritdoc IL1NaffleView
     */
    function getNaffleById(uint256 _id) external view returns (NaffleTypes.L1Naffle memory) {
        return _getNaffleById(_id);
    }
}