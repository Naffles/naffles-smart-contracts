// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {NaffleHolderBaseStorage} from "./NaffleHolderBaseStorage.sol";
import { NaffleTypes } from '../../../../libraries/NaffleTypes.sol';
import { IERC165 } from '@solidstate/contracts/interfaces/IERC165.sol';

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
    ) internal returns (uint256 naffleId) {
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
    }

    function _claimNFT(uint256 _naffleId) internal {}

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
}
