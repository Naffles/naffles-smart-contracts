// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../../../contracts/libraries/NaffleTypes.sol";

/**
 * @title Interface for L2 Naffle View
 */
interface IL2NaffleView {
    /**
     * @notice get the platform fee.
     * @return platformFee the platform fee.
     */
    function getPlatformFee() external view returns (uint256 platformFee);

    /**
     * @notice get the open entry ratio.
     * @return openEntryRatio the open entry ratio.
     */
    function getOpenEntryRatio() external view returns (uint256 openEntryRatio);

    /**
     * @notice get the address of the L1 Naffle contract.
     * @return l1NaffleContractAddress the address of the L1 Naffle contract.
     */
    function getL1NaffleContractAddress() external view returns (address l1NaffleContractAddress);

    /**
     * @notice get the admin role.
     * @return adminRole the admin role.
     */
    function getAdminRole() external view returns (bytes32 adminRole);

    /**
     * @notice get a naffle by its id.
     * @param _id the id of the naffle.
     * @return naffle the naffle.
     */
    function getNaffleById(uint256 _id) external view returns (NaffleTypes.L2Naffle memory);

    /**
     * @notice get the paid ticket contract address.
     * @return paidTicketContractAddress the address of the L2 Paid Ticket contract.
     */
    function getPaidTicketContractAddress() external view returns (address paidTicketContractAddress);

    /**
     * @notice get the open entry ticket contract address.
     * @return openEntryTicketContractAddress the address of the L2 Open Entry Ticket contract.
     */
    function getOpenEntryTicketContractAddress() external view returns (address openEntryTicketContractAddress);

    /**
     * @notice gets the max postpone time.
     * @return maxPostponeTime the max postpone time.
     */
    function getMaxPostponeTime() external view returns (uint256 maxPostponeTime);

    /**
     * @notice gets the platform fees accumulated.
     * @return platformFeesAccumulated the platform fees accumulated.
     */
    function getPlatformFeesAccumulated() external view returns (uint256);

    /**
     * @notice gets the L1 messenger contract address.
     * @return l1MessengerContractAddress the L1 messenger contract address.
     */
    function getL1MessengerContractAddress() external view returns (address);

    /**
     * @notice gets the paid to open entry redeem ratio.
     * @return paidToOpenEntryRedeemRatio the paid to open entry redeem ratio.
     */
    function getPaidToOpenEntryRedeemRatio() external view returns (uint256);

    /**
     * @notice gets the signature signer.
     * @return signatureSigner the signature signer.
     */
    function getSignatureSigner() external view returns (address);

    /**
     * @notice gets the domain name.
     * @return domainName the domain name.
     */
    function getDomainName() external view returns (string memory);
}