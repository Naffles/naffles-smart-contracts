// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library NaffleTypes {
    struct CreateNaffleParams {
        address _ethTokenAddress;
        address _owner;
        uint256 _nftId;
        uint256 _paidTicketSpots;
        uint256 _ticketPriceInWei;
        uint256 _endTime;
        NaffleType _naffleType;
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
}

