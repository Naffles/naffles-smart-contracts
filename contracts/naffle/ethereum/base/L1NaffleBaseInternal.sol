// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {L1NaffleBaseStorage} from "./L1NaffleBaseStorage.sol";
import {NaffleTypes} from "../../../libraries/NaffleTypes.sol";
import { IERC165 } from '@solidstate/contracts/interfaces/IERC165.sol';
import {IZkSync} from "@zksync/contracts/l1/zksync/interfaces/IZkSync.sol";

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
        } else if (IERC165(_ethTokenAddress).supportsInterface(ERC1155_INTERFACE_ID)) {
          tokenContractType = NaffleTypes.TokenContractType.ERC1155;
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

    function _getZkSyncNaffleContractAddress() internal view returns (address) {
        return L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress;
    }
}
