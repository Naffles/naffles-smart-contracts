// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/**
 * @title L1 Naffle Admin Interface.
 */
interface IL1NaffleAdmin {
    /**
     * @notice sets the minimum naffle duration, naffle can't last shorter that this.
     * @param _minimumNaffleDuration the new minimum naffle duration.
     */
    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external;

    /**
     * @notice sets the minimum paid tickets spots. naffle can't have less than this amount of paid tickets.
     * @param _minimumPaidTicketSpots the new minimum paid tickets spots.
     */
    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external;

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
     * @notice cancels a naffle, should only be used if l1->l2 messaging fails.
               and the NFT is stuck as a result
     * @param _naffleId the naffle id to cancel.
     */
    function adminCancelNaffle(uint256 _naffleId) external;

    /**
     * @notice sets the signature signer address.
     * @param _signatureSignerAddress the new signature signer address.
     */
    function setSignatureSignerAddress(address _signatureSignerAddress) external;

    /**
     * @notice sets the collection signature
     * @param _collectionSignature the new collection signature.
     */
    function setCollectionWhitelistSignature(bytes32 _collectionSignature) external;

    /**
     * @notice sets the domain signature
     * @param _domainSignature the new domain signature.
     */
    function setDomainSignature(bytes32 _domainSignature) external;

    /**
     * @notice sets the domain name
     * @param _domainName the new domain name.
     */
    function setDomainName(string memory _domainName) external;

    /**
     * @notice removes admin role from the _admin address.
     * @param _admin the admin address to remove.
     */
    function removeAdmin(address _admin) external;
}
