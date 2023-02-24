// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./L1NaffleBaseInternal.sol";
import "../../libraries/NaffleTypes.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/interfaces/IERC721Receiver.sol";
import "@solidstate/contracts/interfaces/IERC1155Receiver.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleBase.sol";


contract L1NaffleBase is IL1NaffleBase, L1NaffleBaseInternal, AccessControl, IERC721Receiver, IERC1155Receiver {
    function createNaffle(
        NaffleTypes.CreateNaffleParams memory _params
    ) external returns (uint256 naffleId, bytes32 txHash) {
        return _createNaffle(_params);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return
            bytes4(
                keccak256('onERC721Received(address,address,uint256,bytes)')
            );
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return
            bytes4(
                keccak256('onERC1155Received(address,address,uint256,uint256,bytes)')
            );
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure override returns (bytes4) {
        revert NotSupported();
    }

    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        return interfaceId == type(IERC721Receiver).interfaceId || interfaceId == type(IERC1155Receiver).interfaceId;
    }
}
