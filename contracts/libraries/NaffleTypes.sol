// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library NaffleTypes {
    struct CreateZkSyncNaffleParams {
        address ethTokenAddress;
        address owner;
        uint256 naffleId;
        uint256 nftId;
        uint256 paidTicketSpots;
        uint256 ticketPriceInWei;
        uint256 endTime;
        NaffleType naffleType;
    }

    enum NaffleType {
        STANDARD,
        UNLIMITED
    }

    enum TokenContractType {
        ERC721,
        ERC1155
    }

    struct L1Naffle {
        address tokenAddress;
        uint256 nftId;
        uint256 naffleId;
        address owner;
        address winner;
        bool winnerClaimed;
        TokenContractType naffleTokenType;
    }

    struct L2Naffle {
        address ethTokenAddress;
        address owner;
        uint256 naffleId;
        uint256 nftId;
        uint256 paidTicketSpots;
        uint256 freeTicketSpots;
        uint256 numberOfPaidTickets;
        uint256 numberOfFreeTickets;
        uint256 ticketPriceInWei;
        uint256 endTime;
        uint256 winningTicketId;
        TicketType winningTicketType;
        TokenContractType naffleTokenType;
        NaffleStatus status;
        NaffleType naffleType;
    }
}

