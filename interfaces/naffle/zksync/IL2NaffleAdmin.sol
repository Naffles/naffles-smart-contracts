// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/**
 * @notice Interface for the L2 Naffle Admin contract
 */
interface IL2NaffleAdmin {
    /**
     * @notice Set the platform fee
     * @param _platformFee The new platform fee
     */
    function setPlatformFee(uint256 _platformFee) external;

    /**
     * @notice set open entry ticket ratio, for every x tickets there will be x open entry spots. 100 = 1%
     * @param _openEntryTicketRatio the new open entry ticket ratio
     */
    function setOpenEntryRatio(uint256 _openEntryTicketRatio) external;

    /**
     * @notice set the admin address
     * @param _admin the new admin address
     */
    function setAdmin(address _admin) external;

    /**
     * @notice set the address of the L1 Naffle contract
     * @param _l1NaffleContractAddress the new L1 Naffle contract address
     */
    function setL1NaffleContractAddress(address _l1NaffleContractAddress) external;

    /**
     * @notice set paid tickets contract address
     * @param _paidTicketContractAddress the new paid tickets contract address
     */
    function setPaidTicketContractAddress(address _paidTicketContractAddress) external;

    /**
     * @notice set open entry tickets contract address
     * @param _openEntryTicketContractAddress the new open entry tickets contract address
     */
    function setOpenEntryTicketContractAddress(address _openEntryTicketContractAddress) external;

    /**
     * @notice admin cancel a naffle, cancels the naffle if its in a valid state to cancel
     * @param _naffleId the naffle id
     */
    function adminCancelNaffle(uint256 _naffleId) external;

    /**
     * @notice sets the L1 messenger contract address, used for messaging to L1
     * @param _l1MessengerContractAddress the new L1 messenger contract address
     */
    function setL1MessengerContractAddress(address _l1MessengerContractAddress) external;

    /**
     * @notice withdraw platform fees, fails if the amount is greater than the platform fees balance
     * @param _amount the amount to withdraw
     * @param _to the address to withdraw to
     */
    function withdrawPlatformFees(uint256 _amount, address _to) external;

    /**
     * @notice set the max postpone time
     * @param _maxPostponeTime the new max postpone time
     */
    function setMaxPostponeTime(uint256 _maxPostponeTime) external;

    /**
     * @notice set the VRF manager address
     * @param _vrfManager the new VRF manager address
     */
    function setVRFManager(address _vrfManager) external;

    /**
     * @notice sets the platformDiscountSignatureHash
     * @param _platformDiscountSignatureHash the new platformDiscountSignatureHash
     */
    function setPlatformDiscountSignatureHash(bytes32 _platformDiscountSignatureHash) external;

    /**
     * @notice sets the signature signer address.
     * @param _signatureSignerAddress the new signature signer address.
     */
    function setSignatureSignerAddress(address _signatureSignerAddress) external;
}
