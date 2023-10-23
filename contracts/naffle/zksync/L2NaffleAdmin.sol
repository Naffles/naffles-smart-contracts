// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseInternal.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleAdmin.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/access/ownable/SafeOwnable.sol";

contract L2NaffleAdmin is IL2NaffleAdmin, L2NaffleBaseInternal, AccessControl, SafeOwnable {

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setAdmin(address _admin) external onlyOwner {
        _grantRole(_getAdminRole(), _admin);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setPlatformFee(uint256 _platformFee) external onlyRole(_getAdminRole()) {
        _setPlatformFee(_platformFee);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setOpenEntryRatio(uint256 _openEntryTicketRatio) external onlyRole(_getAdminRole()) {
        _setOpenEntryRatio(_openEntryTicketRatio);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setL1NaffleContractAddress(address _l1NaffleContractAddress) external onlyRole(_getAdminRole()) {
        _setL1NaffleContractAddress(_l1NaffleContractAddress);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setPaidTicketContractAddress(address _paidTicketContractAddress) external onlyRole(_getAdminRole()) {
        _setPaidTicketContractAddress(_paidTicketContractAddress);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setOpenEntryTicketContractAddress(address _openEntryTicketContractAddress) external onlyRole(_getAdminRole()) {
        _setOpenEntryTicketContractAddress(_openEntryTicketContractAddress);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function adminCancelNaffle(uint256 _naffleId) external onlyRole(_getAdminRole()) {
        _adminCancelNaffle(_naffleId);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setL1MessengerContractAddress(address _l1MessengerContractAddress) external onlyRole(_getAdminRole()) {
        _setL1MessengerContractAddress(_l1MessengerContractAddress);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function withdrawPlatformFees(uint256 _amount, address _to) external onlyRole(_getAdminRole()) {
        _withdrawPlatformFees(_amount, _to);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setMaxPostponeTime(uint256 _maxPostponeTime) external onlyRole(_getAdminRole()) {
        _setMaxPostponeTime(_maxPostponeTime);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setVRFManager(address _vrfManager) external onlyRole(_getAdminRole()) {
        _grantRole(VRF_ROLE, _vrfManager);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setSignatureSignerAddress(address _signatureSignerAddress) external onlyRole(_getAdminRole()) {
        _setSignatureSignerAddress(_signatureSignerAddress);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setDomainSignature(bytes32 _domainSignature) external onlyRole(_getAdminRole()) {
        _setDomainSignature(_domainSignature);
    }

    /**
     * @inheritdoc IL2NaffleAdmin
     */
    function setDomainName(string memory _domainName) external onlyRole(_getAdminRole()) {
        _setDomainName(_domainName);
    }
}
