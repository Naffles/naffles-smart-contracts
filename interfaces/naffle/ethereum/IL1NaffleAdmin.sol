// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/**
 * @title L1 Naffle Admin Interface.
 */
interface IL1NaffleAdmin {
    /**
     * @notice sets the minimum naffle duration, naffles can't last shorter that this.
     * @param _minimumNaffleDuration the new minimum naffle duration.
     */
    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external;

    /**
     * @notice sets the minimum paid tickets spots. naffles can't have less than this amount of paid tickets.
     * @param _minimumPaidTicketSpots the new minimum paid tickets spots.
     */
    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external;

    /**
     * @notice sets the minimum paid ticket price in wei. naffles can't have paid tickets with a price lower than this.
     * @param _minimumPaidTicketPriceInWei the new minimum paid ticket price in wei.
     */
    function setMinimumPaidTicketPriceInWei(uint256 _minimumPaidTicketPriceInWei) external;

    /**
     * @notice sets the L2 zksync naffle contract address.
     * @param _zkSyncNaffleContractAddress the new L2 zksync naffle contract address.
     */
    function setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) external;

    /**
     * @notice sets the L2 zksync address, used for messaging to L2.
     * @param _zkSyncAddress the new L2 zksync address.
     */
    function setZkSyncAddress(address _zkSyncAddress) external;

    /**
     * @notice sets the Founders Key address.
     * @param _foundersKeyAddress the new Founders Key Address.
     */
    function setFoundersKeyAddress(address _foundersKeyAddress) external;

    /**
     * @notice sets the Founders Key Placeholder Address.
     * @param _foundersKeyPlaceholderAddress the new Founders Key Placeholder Address.
     */
    function setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) external;

    /**
     * @notice gives admin role to the _admin address.
     * @param _admin the new admin address.
     */
    function setAdmin(address _admin) external;

    /**
     * @notice consumes the admin cancel message from L2, cancels the naffle on L1 and returns the NFT to the owner.
     */
    function consumeAdminCancelMessage(
        address _zkSyncAddress,
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external;
}