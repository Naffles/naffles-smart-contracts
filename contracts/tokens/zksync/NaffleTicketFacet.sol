
import "@chire-labs/contracts/ERC721AUpgradable.sol";

error UnableToWithdraw(uint256 amount);

contract NaffleTicketFacet is ERC721AUpgradable, NaffleTicketFacetInternal {
    function initialize() initializerERC721A initializer public {
        __ERC721A_init('Naffle Ticket', 'TICKET');
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

    function withdraw() external onlyRole(WITHDRAW_ROLE) {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        if (!success) { revert UnableToWithdraw({amount: address(this).balance});}
    }

    function _baseURI() internal view override returns (string memory) {
      return _getBaseURI();
    }
}
