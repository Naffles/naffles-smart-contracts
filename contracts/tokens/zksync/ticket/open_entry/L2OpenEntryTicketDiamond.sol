// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
//import '@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol';
//import '@solidstate/contracts/token/ERC721/ISolidStateERC721.sol';
import "./L2OpenEntryTicketBaseInternal.sol";

//import '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import '@solidstate/contracts/introspection/ERC165/base/ERC165Base.sol';
import "@chiru-labs/contracts/ERC721AUpgradeable.sol";

contract L2OpenEntryTicketDiamond is SolidStateDiamond, AccessControl, L2OpenEntryTicketBaseInternal {
    constructor(
        address _admin,
        string memory _domainName
    ) SolidStateDiamond() {
        _grantRole(AccessControlStorage.DEFAULT_ADMIN_ROLE, _admin);
        //ERC721MetadataStorage.Layout storage metadata = ERC721MetadataStorage.layout();
        _setSignatureSignerAddress(msg.sender);

        _initializeERC721A('Open entry', 'OPENENTRY');
        //metadata.name = "OPENTICKET";
        //metadata.symbol = "OPENTICKET";

        _setSignatureSignerAddress(msg.sender);
        _setStakingRewardSignatureHash(
            keccak256(abi.encodePacked("claimStakingRewards(uint256 amount,uint256 totalClaimed,address targetAddress)"))
        );
        _setDomainSignature(keccak256(abi.encodePacked("EIP712Domain(string name)")));
        _setDomainName(_domainName);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Base, ERC721AUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
