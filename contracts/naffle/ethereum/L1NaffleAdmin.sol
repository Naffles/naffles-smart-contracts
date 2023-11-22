// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L1NaffleBaseInternal.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleAdmin.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/access/ownable/SafeOwnable.sol";

contract L1NaffleAdmin is IL1NaffleAdmin, L1NaffleBaseInternal, AccessControl, SafeOwnable {
    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external onlyRole(_getAdminRole()) {
        _setMinimumNaffleDuration(_minimumNaffleDuration);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external onlyRole(_getAdminRole()) {
        _setMinimumPaidTicketSpots(_minimumPaidTicketSpots);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setMinimumPaidTicketPriceInWei(uint256 _minimumPaidTicketPriceInWei) external onlyRole(_getAdminRole()) {
        _setMinimumPaidTicketPriceInWei(_minimumPaidTicketPriceInWei);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setZkSyncNaffleContractAddress(address _zksyncNaffleContractAddress) external onlyRole(_getAdminRole()) {
        _setZkSyncNaffleContractAddress(_zksyncNaffleContractAddress);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setZkSyncAddress(address _zksyncAddress) external onlyRole(_getAdminRole()) {
        _setZkSyncAddress(_zksyncAddress);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setFoundersKeyAddress(address _foundersKeyAddress) external onlyRole(_getAdminRole()) {
        _setFoundersKeyAddress(_foundersKeyAddress);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) external onlyRole(_getAdminRole()) {
        _setFoundersKeyPlaceholderAddress(_foundersKeyPlaceholderAddress);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setAdmin(address _admin) external onlyOwner {
        _grantRole(_getAdminRole(), _admin);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function adminCancelNaffle(uint256 _naffleId) external onlyRole(_getAdminRole()) {
        _cancelNaffle(_naffleId);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setSignatureSignerAddress(address _signatureSignerAddress) external onlyRole(_getAdminRole()) {
        _setSignatureSignerAddress(_signatureSignerAddress);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setCollectionWhitelistSignature(bytes32 _collectionSignature) external onlyRole(_getAdminRole()) {
        _setCollectionWhitelistSignature(_collectionSignature);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setDomainSignature(bytes32 _domainSignature) external onlyRole(_getAdminRole()) {
        _setDomainSignature(_domainSignature);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function setDomainName(string memory _domainName) external onlyRole(_getAdminRole()) {
        _setDomainName(_domainName);
    }

    /**
     * @inheritdoc IL1NaffleAdmin
     */
    function removeAdmin(address _admin) external onlyOwner {
        _revokeRole(_getAdminRole(), _admin);
    }
}
