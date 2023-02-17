// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {NaffleHolderBaseStorage} from "./NaffleHolderBaseStorage.sol";
import { NaffleTypes } from '../../../../libraries/NaffleTypes.sol';
import { IERC165 } from '@solidstate/contracts/interfaces/IERC165.sol';
import {INaffleBase} from "../../../../../interfaces/naffle/zksync/naffle/base/INaffleBase.sol";
import {AccessControlStorage} from "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import {IZkSync} from "@zksync/contracts/l1/zksync/interfaces/IZkSync.sol";

error InvalidTokenType();
error InvalidEndTime(uint256 endTime);
error InvalidPaidTicketSpots(uint256 spots);
error NotEnoughFunds(uint256 funds);
error NotEnoughPaidTicketSpots(uint256 tickets);
error NaffleNotActive();
error InvalidNaffleId(uint256 naffleId);
error InvalidNaffleStatus(NaffleTypes.NaffleStatus status);
error NotNaffleOwner(uint256 naffleId);
error NaffleNotFinished(uint256 naffleId);
error NaffleIsFinished(uint256 naffleId);
error InvalidPostponeTime();
error InvalidWinningNumber(uint256 winningNumber);
error InsufficientPlatformFeeBalance();
error UnableToWithdraw(uint256 amount);

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

        layout.naffles[naffleId] = NaffleTypes.NaffleHolder({
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

    function _selectWinner(uint256 _naffleId, uint256 _totalTickets) internal {
        NaffleHolderBaseStorage.Layout storage layout = NaffleHolderBaseStorage.layout();
        NaffleTypes.NaffleHolder storage naffle = layout.naffles[_naffleId];
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
