// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "./L2NaffleBaseInternal.sol";

contract L2NaffleDiamond is SolidStateDiamond, AccessControl, L2NaffleBaseInternal {
    constructor(
        address _admin,
        uint256 _platformFee,
        uint256 _openEntryRatio,
        address _l1MessengerContractAddress,
        address _l1NaffleContractAddress,
        address _paidTicketContractAddress,
        address _openEntryTicketContractAddress,
        string memory _domainName
    ) SolidStateDiamond() {
        _grantRole(_getAdminRole(), _admin);
        _grantRole(VRF_ROLE, _admin);
        _setPlatformFee(_platformFee);
        _setOpenEntryRatio(_openEntryRatio);
        _setL1MessengerContractAddress(_l1MessengerContractAddress);
        _setPaidTicketContractAddress(_paidTicketContractAddress);
        _setOpenEntryTicketContractAddress(_openEntryTicketContractAddress);
        _setL1NaffleContractAddress(_l1NaffleContractAddress);
        _setSignatureSignerAddress(msg.sender);
        _setPlatformDiscountSignatureHash(
            keccak256(abi.encodePacked("PlatformDiscount(uint256 platformDiscountInPercent,address winner,uint256 expireTimestamp)"))
        );
        _setDomainSignature(keccak256(abi.encodePacked("EIP712Domain(string name)")));
        _setDomainName(_domainName);
    }
}
