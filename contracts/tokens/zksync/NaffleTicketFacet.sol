
import "@chire-labs/contracts/ERC721AUpgradable.sol";
import "@openzeppelin-upgradable/contracts/access/AccessControlUpgradable.sol";

error UnableToWithdraw(uint256 amount);

contract NaffleTicketFacet is ERC721AUpgradable, NaffleTicketFacetInternal, AccessControlUpgradable {
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
        return bytes(_baseURI()).length != 0 ? _getBaseURI()): "";
    }

    function _baseURI() internal view override returns (string memory) {
      return _getBaseURI();
    }

    function setBaseURI(string memory baseURI) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setBaseURI(baseURI);
    }
}
