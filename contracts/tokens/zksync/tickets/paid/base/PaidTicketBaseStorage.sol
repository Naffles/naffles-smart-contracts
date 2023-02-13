// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library PaidTIcketBaseStorage {
    bytes32 internal constant STORAGE_SLOT = keccak256("naffles.contract.tokens.zksync.tickets.paid.PaidTIcketBaseStorage");
    
    struct PaidTicket {
      owner: address;
      price_in_wei: uint256;
      naffle_id: uint256;
      winning_ticket: bool;
    }

    struct Storage {
      
      mapping(uint256 => PaidTicket) paidTickets;
    }

    function layout() internal pure returns (Storage storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }
}

