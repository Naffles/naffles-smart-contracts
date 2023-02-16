// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC721AReceiver} from "@solidstate/contracts/interfaces/IERC721Receiver.sol"};
import {ERC1155Receiver} from "@solidstate/contracts/interfaces/IERC1155Receiver.sol"};

error NotSupported();

contract NaffleHolderBase is IERC721Receiver, IERC1155Receiver {
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
}
