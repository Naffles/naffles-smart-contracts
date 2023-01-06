
import "@chiru-labs-upgradeable/contracts/ERC721AUpgradeable.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "./NaffleTicketFacetInternal.sol";

error UnableToWithdraw(uint256 amount);

contract NaffleTicketFacet is ERC721AUpgradeable, NaffleTicketFacetInternal, AccessControl{
    function initialize() initializerERC721A public {
        __ERC721A_init('Naffle Ticket', 'TICKET');
        _grantRole(AccessControlStorage.DEFAULT_ADMIN_ROLE, msg.sender);
     }

    function exists(uint32 tokenId) external view returns (bool) {
        return _exists(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return bytes(_baseURI()).length != 0 ? _getBaseURI() : "";
    }

    function _baseURI() internal view override returns (string memory) {
      return _getBaseURI();
    }

    function setBaseURI(string memory baseURI) 
        external 
        onlyRole(AccessControlStorage.DEFAULT_ADMIN_ROLE)
    {
        _setBaseURI(baseURI);
    }
}
