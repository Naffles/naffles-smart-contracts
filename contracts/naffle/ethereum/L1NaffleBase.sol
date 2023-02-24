// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {L1NaffleBaseInternal} from "./L1NaffleBaseInternal.sol";
import {NaffleTypes} from "../../../libraries/NaffleTypes.sol";
import { AccessControl } from "@solidstate/contracts/access/access_control/AccessControl.sol";
import {IERC721Receiver} from "@solidstate/contracts/interfaces/IERC721Receiver.sol";
import {IERC1155Receiver} from "@solidstate/contracts/interfaces/IERC1155Receiver.sol";
import {IL1NaffleBase} from "../../../../interfaces/naffle/ethereum/base/IL1NaffleBase.sol";

error NotSupported();

abstract contract L1NaffleBase is IL1NaffleBase, L1NaffleBaseInternal, AccessControl, IERC721Receiver, IERC1155Receiver {

    function createNaffle(
        address _ethTokenAddress, 
        address _owner,
        uint256 _nftId, 
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime, 
        NaffleTypes.NaffleType _naffleType
    ) external returns (uint256 naffleId, bytes32 txHash) {
        return _createNaffle(
            _ethTokenAddress, 
            _owner,
            _nftId, 
            _paidTicketSpots,
            _ticketPriceInWei,
            _endTime, 
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

    function getFoundersKeyAddress() external view returns (address) {
        return _getFoundersKeyAddress();
    }

    function setFoundersKeyAddress(address _foundersKeyAddress) external onlyRole(_getAdminRole()) {
        _setFoundersKeyAddress(_foundersKeyAddress);
    }

    function getFoundersKeyPlaceholderAddress() external view returns (address) {
        return _getFoundersKeyPlaceholderAddress();
    }

    function setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) external onlyRole(_getAdminRole()) {
        _setFoundersKeyPlaceholderAddress(_foundersKeyPlaceholderAddress);
    }
}
