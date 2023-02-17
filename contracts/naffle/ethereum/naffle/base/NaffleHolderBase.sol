// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC721Receiver} from "@solidstate/contracts/interfaces/IERC721Receiver.sol";
import {IERC1155Receiver} from "@solidstate/contracts/interfaces/IERC1155Receiver.sol";
import {NaffleHolderBaseInternal} from "./NaffleHolderBaseInternal.sol";
import { NaffleTypes } from '../../../../libraries/NaffleTypes.sol';

error NotSupported();

abstract contract NaffleHolderBase is NaffleHolderBaseInternal, IERC721Receiver, IERC1155Receiver {
  function createNaffle(
      address _ethTokenAddress, 
      address _owner,
      uint256 _nftId, 
      uint256 _paidTicketSpots,
      uint256 _ticketPriceInWei,
      uint256 _endTime, 
      NaffleTypes.NaffleType _naffleType
  ) internal returns (uint256 naffleId) {
      return _createNaffle(
          _ethTokenAddress, 
          _owner,
          _nftId, 
          _paidTicketSpots,
          _endTime, 
          _ticketPriceInWei,
          _naffleType
      );
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
