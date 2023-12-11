// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseInternal.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleView.sol";
import "../../libraries/NaffleTypes.sol";

contract L2NaffleView is IL2NaffleView, L2NaffleBaseInternal {
    /**
     * @inheritdoc IL2NaffleView
     */
    function getPlatformFee() external view returns (uint256) {
        return _getPlatformFee();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getOpenEntryRatio() external view returns (uint256) {
        return _getOpenEntryRatio();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getL1NaffleContractAddress() external view returns (address) {
        return _getL1NaffleContractAddress();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getNaffleById(uint256 _id) external view returns (NaffleTypes.L2Naffle memory) {
        return _getNaffleById(_id);
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getAdminRole() external pure returns (bytes32) {
        return _getAdminRole();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getPaidTicketContractAddress() external view returns (address) {
        return _getPaidTicketContractAddress();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getOpenEntryTicketContractAddress() external view returns (address) {
        return _getOpenEntryTicketContractAddress();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getMaxPostponeTime() external view returns (uint256) {
        return _getMaxPostponeTime();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getPlatformFeesAccumulated() external view returns (uint256) {
        return _getPlatformFeesAccumulated();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getL1MessengerContractAddress() external view returns (address) {
        return _getL1MessengerContractAddress();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getSignatureSigner() external view returns (address) {
        return _getSignatureSigner();
    }

    /**
     * @inheritdoc IL2NaffleView
     */
    function getDomainName() external view returns (string memory) {
        return _getDomainName();
    }
}
