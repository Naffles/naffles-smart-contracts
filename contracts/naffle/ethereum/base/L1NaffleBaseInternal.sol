// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {NaffleHolderBaseStorage} from "./NaffleHolderBaseStorage.sol";
import {NaffleTypes} from "../../../libraries/NaffleTypes.sol";

abstract contract NaffleBaseHolderInternal {
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
    ) {
        
    }
}
