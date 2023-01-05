// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./NaffleTicketStorage.sol";

contract NaffleTicketFacetInternal {
    function _storage() internal pure returns (NaffleTicketStorage.Storage storage s) {
        s = NaffleTicketStorage.layout();
    }

    function _getBaseURI() internal view returns (string memory) {
        return _storage().baseURI;
    }

    function setBaseURI(string memory baseURI) internal {
        _storage().baseURI = baseURI;
    }
}
