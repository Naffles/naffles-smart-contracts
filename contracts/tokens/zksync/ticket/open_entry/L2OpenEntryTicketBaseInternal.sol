// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2OpenEntryTicketStorage.sol";

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "@solidstate/contracts/token/ERC721/enumerable/ERC721EnumerableInternal.sol";
import "../../../../../interfaces/naffle/zksync/IL2NaffleView.sol";
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBaseInternal.sol";
import "@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@chiru-labs/contracts/ERC721A__Initializable.sol";
import "@chiru-labs/contracts/ERC721AStorage.sol";
//import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
//import "@openzeppelin/contracts/utils/introspection/IERC165.sol as OpenZeppelinIERC165";
//import "@solidstate/contracts/introspection/IERC165.sol as SolidStateIERC165";

abstract contract L2OpenEntryTicketBaseInternal is IL2OpenEntryTicketBaseInternal, AccessControlInternal, ERC721A__Initializable {
    function _initializeERC721A(string memory _name, string memory _symbol) initializerERC721A internal {
        ERC721AStorage.layout()._name = _name;
        ERC721AStorage.layout()._symbol = _symbol;
        ERC721AStorage.layout()._currentIndex = 1;
    }

    /**
     * @notice get the admin role.
     * @return adminRole the admin role.
     */
    function _getAdminRole() internal pure returns (bytes32 adminRole) {
        adminRole = AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    /**
     * @notice gets the l2 naffle contract address
     * @return l2NaffleContractAddress the l2 naffle contract address.
     */
    function _getL2NaffleContractAddress() internal view returns (address l2NaffleContractAddress) {
        l2NaffleContractAddress = L2OpenEntryTicketStorage.layout().l2NaffleContractAddress;
    }

    /**
     * @notice sets the l2 naffle contract address.
     * @param _l2NaffleContractAddress the l2 naffle contract address.
     */
    function _setL2NaffleContractAddress(address _l2NaffleContractAddress) internal {
        L2OpenEntryTicketStorage.layout().l2NaffleContractAddress = _l2NaffleContractAddress;
    }

    /**
     * @notice sets the base URI
     * @param _baseURI the base URI.
     */
    function _setBaseURI(string memory _baseURI) internal {
        L2OpenEntryTicketStorage.layout().baseURI = _baseURI;
    }

    /**
     * @notice gets open entry ticket by its id
     * @param _ticketId the id of the ticket.
     * @return ticket the open entry ticket.
     */
    function _getOpenEntryTicketById(uint256 _ticketId) internal view returns (NaffleTypes.OpenEntryTicket memory ticket) {
        L2OpenEntryTicketStorage.Layout storage l = L2OpenEntryTicketStorage.layout();
        ticket = l.openEntryTickets[_ticketId];
    }

    /**
     * @notice sets the signature signer address.
     * @param _signatureSignerAddress the signature signer address.
     */
    function _setSignatureSignerAddress(address _signatureSignerAddress) internal {
        L2OpenEntryTicketStorage.layout().signatureSigner = _signatureSignerAddress;
    }

    /**
     * @notice gets the signature signer.
     * @return signatureSigner the signature signer.
     */
    function _getSignatureSigner() internal view returns (address signatureSigner) {
        signatureSigner = L2OpenEntryTicketStorage.layout().signatureSigner;
    }

    /**
     * @notice gets the domain name.
     * @return domainName the domain name.
     */
    function _getDomainName() internal view returns (string memory domainName) {
        domainName = L2OpenEntryTicketStorage.layout().domainName;
    }

    /**
     * @notice gets the domain signature.
     * @param _domainSignature the domain signature.
     */
    function _setDomainSignature(bytes32 _domainSignature) internal {
        L2OpenEntryTicketStorage.layout().domainSignature = _domainSignature;
    }

    /**
     * @notice sets the exchange rate signature hash.
     * @param _stakingRewardSignatureHash the exchange rate signature hash.
     */
    function _setStakingRewardSignatureHash(bytes32 _stakingRewardSignatureHash ) internal {
        L2OpenEntryTicketStorage.layout().stakingRewardSignatureHash  = _stakingRewardSignatureHash;
    }

    /**
     * @notice gets the domain signature.
     * @param _domainName the domain signature.
     */
    function _setDomainName(string memory _domainName) internal {
        L2OpenEntryTicketStorage.layout().domainName = _domainName;
    }
}
