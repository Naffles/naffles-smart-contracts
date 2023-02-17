// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {NaffleHolderBaseStorage} from "./NaffleHolderBaseStorage.sol";
import { NaffleTypes } from '../../../../libraries/NaffleTypes.sol';
import { IERC165 } from '@solidstate/contracts/interfaces/IERC165.sol';
import {INaffleBase} from "../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";
import {AccessControlStorage} from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";

import {IZkSync} from "@zksync/contracts/zksync/interfaces/IZkSync.sol";

error InvalidTokenType();
error InvalidEndTime(uint256 endTime);
error InvalidPaidTicketSpots(uint256 spots);


contract NaffleHolderBaseInternal {
    bytes4 internal constant ERC721_INTERFACE_ID = 0x80ac58cd;
    bytes4 internal constant ERC1155_INTERFACE_ID = 0xd9b67a26;

    function _createNaffle(
        address _ethTokenAddress, 
        address _owner,
        uint256 _nftId, 
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime, 
        NaffleTypes.NaffleType _naffleType
    ) internal returns (uint256 naffleId, bytes32 txHash) {
        NaffleHolderBaseStorage.Layout storage layout = NaffleHolderBaseStorage.layout();
        
        if (block.timestamp + layout.minimumNaffleDuration < _endTime) {
            revert InvalidEndTime(_endTime);
        }
         
        ++layout.numberOfNaffles;
        naffleId = layout.numberOfNaffles;

        if (
            (_naffleType == NaffleTypes.NaffleType.UNLIMITED && _paidTicketSpots != 0) ||
            _paidTicketSpots < layout.minimumPaidTicketSpots
        ) {
            // Unlimited naffles don't have an upper limit on paid or free tickets.
            revert InvalidPaidTicketSpots(_paidTicketSpots);
        }

        NaffleTypes.TokenContractType tokenContractType;
        if (IERC165(_ethTokenAddress).supportsInterface(ERC721_INTERFACE_ID)) {
          tokenContractType = NaffleTypes.TokenContractType.ERC721;
        } else if (IERC165(_ethTokenAddress).supportsInterface(ERC1155_INTERFACE_ID)) {
          tokenContractType = NaffleTypes.TokenContractType.ERC1155;
        } else {
          revert InvalidTokenType();
        }

        IZkSync zksync = IZkSync(_getZkSyncAddress());
        txHash = zksync.requestL2Transaction{value: msg.value}(
            // The address of the L2 contract to call
            _getZkSyncNaffleContractAddress(),
            // We pass no ETH with the call
            0,
            // Encoding the calldata for the execute
            abi.encodeWithSignature(
              "createNaffle(address, address, uint256, uint256, uint256, uint256, uint8)", 
              _ethTokenAddress, 
              _owner, 
              _nftId, 
              _paidTicketSpots, 
              _ticketPriceInWei, 
              _endTime, 
              tokenContractType
            ),
            // Gas limit
            10000,
            // gas price per pubdata byte
            800,
            // factory dependencies
            new bytes[](0),
            // refund address
            address(0)
        );
    }

    function _claimNFT(uint256 _naffleId) internal {}

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getMinimumNaffleDuration() internal view returns (uint256) {
        return NaffleHolderBaseStorage.layout().minimumNaffleDuration;
    }

    function _setMinimumNaffleDuration(uint256 _minimumNaffleDuration) internal {
        NaffleHolderBaseStorage.layout().minimumNaffleDuration = _minimumNaffleDuration;
    }

    function _getMinimumPaidTicketSpots() internal view returns (uint256) {
        return NaffleHolderBaseStorage.layout().minimumPaidTicketSpots;
    }

    function _setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) internal {
        NaffleHolderBaseStorage.layout().minimumPaidTicketSpots = _minimumPaidTicketSpots;
    }

    function _setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) internal {
        NaffleHolderBaseStorage.layout().zkSyncNaffleContractAddress = _zkSyncNaffleContractAddress;
    }

    function _getZkSyncNaffleContractAddress() internal view returns (address) {
        return NaffleHolderBaseStorage.layout().zkSyncNaffleContractAddress;
    }

    function _setZkSyncAddress(address _zkSyncAddress) internal {
        NaffleHolderBaseStorage.layout().zkSyncAddress = _zkSyncAddress;
    }

    function _getZkSyncAddress() internal view returns (address) {
        return NaffleHolderBaseStorage.layout().zkSyncAddress;
    }
}
