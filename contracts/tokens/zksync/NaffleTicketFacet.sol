
import "@chiru-labs-upgradeable/contracts/ERC721AUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import "./NaffleTicketFacetInternal.sol";

error UnableToWithdraw(uint256 amount);

contract NaffleTicketFacet is ERC721AUpgradeable, NaffleTicketFacetInternal, AccessControlUpgradeable {
    function initialize() initializerERC721A initializer public {
        __ERC721A_init('Naffle Ticket', 'TICKET');
        __AccessControl_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
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

    function setBaseURI(string memory baseURI) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setBaseURI(baseURI);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721AUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return
            interfaceId == type(IERC721AUpgradeable).interfaceId ||
            interfaceId == type(AccessControlUpgradeable).interfaceId;
    }
}
