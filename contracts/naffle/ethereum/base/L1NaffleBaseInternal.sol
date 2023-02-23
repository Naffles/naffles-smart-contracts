// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {L1NaffleBaseStorage} from "./L1NaffleBaseStorage.sol";
import {NaffleTypes} from "../../../libraries/NaffleTypes.sol";
import { IERC165 } from '@solidstate/contracts/interfaces/IERC165.sol';
import { IERC721 } from '@solidstate/contracts/interfaces/IERC721.sol';
import { IERC1155 } from '@solidstate/contracts/interfaces/IERC1155.sol';

import {IZkSync} from "@zksync/contracts/l1/zksync/interfaces/IZkSync.sol";
import {AccessControlStorage} from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";

error InvalidEndTime(uint256 endTime);
error InvalidTokenType();
error NotEnoughPaidTicketSpots(uint256 tickets);
error InvalidPaidTicketSpots(uint256 spots);

abstract contract L1NaffleBaseInternal {
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
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        
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
            IERC721(_ethTokenAddress).transferFrom(msg.sender, address(this), _nftId);
        } else if (IERC165(_ethTokenAddress).supportsInterface(ERC1155_INTERFACE_ID)) {
            tokenContractType = NaffleTypes.TokenContractType.ERC1155;
            IERC1155(_ethTokenAddress).safeTransferFrom(msg.sender,  address(this), _nftId);
        } else {
            revert InvalidTokenType();
        }

        layout.naffles[naffleId] = NaffleTypes.L1Naffle({
            tokenAddress: _ethTokenAddress,
            nftId: _nftId,
            naffleId: naffleId,
            owner: _owner,
            winner: address(0),
            winnerClaimed: false,
            naffleTokenType: tokenContractType
        });

        IZkSync zksync = IZkSync(_getZkSyncNaffleContractAddress());
        txHash = zksync.requestL2Transaction{value: msg.value}(
            _getZkSyncNaffleContractAddress(),
            0,
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

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getMinimumNaffleDuration() internal view returns (uint256) {
        return L1NaffleBaseStorage.layout().minimumNaffleDuration;
    }

    function _setMinimumNaffleDuration(uint256 _minimumNaffleDuration) internal {
        L1NaffleBaseStorage.layout().minimumNaffleDuration = _minimumNaffleDuration;
    }

    function _getMinimumPaidTicketSpots() internal view returns (uint256) {
        return L1NaffleBaseStorage.layout().minimumPaidTicketSpots;
    }

    function _setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) internal {
        L1NaffleBaseStorage.layout().minimumPaidTicketSpots = _minimumPaidTicketSpots;
    }

    function _setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) internal {
        L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress = _zkSyncNaffleContractAddress;
    }

    function _getZkSyncNaffleContractAddress() internal view returns (address) {
        return L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress;
    }

    function _setZkSyncAddress(address _zkSyncAddress) internal {
        L1NaffleBaseStorage.layout().zkSyncAddress = _zkSyncAddress;
    }

    function _getZkSyncAddress() internal view returns (address) {
        return L1NaffleBaseStorage.layout().zkSyncAddress;
    }
}
