// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./NaffleTicketStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contract/introspection/base/ERC165BaseInternal.sol";

contract NaffleTicketFacetInternal is ERC165BaseInternal {
    function _storage() internal pure returns (NaffleTicketStorage.Storage storage s) {
        s = NaffleTicketStorage.layout();
    }

    function _getBaseURI() internal view returns (string memory) {
        return _storage().baseURI;
    }

    function _setBaseURI(string memory baseURI) internal {
        _storage().baseURI = baseURI;
    }

    function _setupSupportsInterface() internal {
        _setSupportsInterface(0x01ffc9a7, true);
        _setSupportsInterface(0x80ac58cd, true);
        _setSupportsInterface(0x5b5e139f, true);
        _setSupportsInterface(0x7965db0b, true);
    }
}
