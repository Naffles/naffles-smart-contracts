// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC721Receiver} from "@solidstate/contracts/interfaces/IERC721Receiver.sol";
import {IERC1155Receiver} from "@solidstate/contracts/interfaces/IERC1155Receiver.sol";
import { AccessControl } from "@solidstate/contracts/access/access_control/AccessControl.sol";
import {NaffleHolderBaseInternal} from "./NaffleHolderBaseInternal.sol";
import { NaffleTypes } from '../../../../libraries/NaffleTypes.sol';


error UnableToWithdraw(uint256 amount);
error NotSupported();
error NotAllowed();

abstract contract NaffleHolderBase is AccessControl, NaffleHolderBaseInternal, IERC721Receiver, IERC1155Receiver {
  constructor(address _admin) {
      _grantRole(_getAdminRole(), _admin);
  }

  function createNaffle(
      address _ethTokenAddress, 
      address _owner,
      uint256 _nftId, 
      uint256 _paidTicketSpots,
      uint256 _ticketPriceInWei,
      uint256 _endTime, 
      NaffleTypes.NaffleType _naffleType
  ) internal returns (uint256 naffleId, bytes32 txHash) {
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

  function selectWinner(uint256 _naffleId, uint256 _totalTickets) external {
      _selectWinner(_naffleId, _totalTickets);
  }

  function withdraw() external onlyRole(_getAdminRole()) {
    (bool success, ) = msg.sender.call{value: address(this).balance}("");
    if (!success) { revert UnableToWithdraw({amount: address(this).balance});}
  }

  function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
    return interfaceId == type(IERC721Receiver).interfaceId || interfaceId == type(IERC1155Receiver).interfaceId;
  }

  function getMinimumNaffleDuration() external view returns (uint256) {
    return _getMinimumNaffleDuration();
  }

  function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external onlyRole(_getAdminRole()) {
      _setMinimumNaffleDuration(_minimumNaffleDuration);
  }

  function getMinimumPaidTicketSpots() external view returns (uint256) {
      return _getMinimumPaidTicketSpots();
  }

  function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external onlyRole(_getAdminRole()) {
      _setMinimumPaidTicketSpots(_minimumPaidTicketSpots);
  }

  function getZkSyncNaffleContractAddress() external view returns (address) {
      return _getZkSyncNaffleContractAddress();
  }

  function setZkSyncNaffleContractAddress(address _zksyncNaffleContractAddress) external onlyRole(_getAdminRole()) {
      _setZkSyncNaffleContractAddress(_zksyncNaffleContractAddress);
  }

  function getZkSyncAddress() external view returns (address) {
      return _getZkSyncAddress();
  }

  function setZkSyncAddress(address _zksyncAddress) external onlyRole(_getAdminRole()) {
      _setZkSyncAddress(_zksyncAddress);
  }
}
