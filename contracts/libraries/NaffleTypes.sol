// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

library NaffleTypes {
    struct L2MessageParams {
        uint256 l2GasLimit;
        uint256 l2GasPerPubdataByteLimit;
    }

    struct PlatformDiscountData {
        // 100 = 1%
        uint256 platformDiscountInPercent;
        uint256 expireTimestamp;
    }

    struct PlatformDiscountParams {
        PlatformDiscountData platformDiscountData;
        bytes platformDiscountSignature;
    }

    struct ExchangeRateData {
        string name;
        string version;
        uint256 exchangeRate;
        uint256 expireTimestamp;
    }

    struct ExchangeRateParams {
        ExchangeRateData exchangeRateData;
        bytes exchangeRateSignature;
    }

    struct CreateZkSyncNaffleParams {
        NaffleTokenInformation naffleTokenInformation;
        address owner;
        uint256 naffleId;
        uint256 paidTicketSpots;
        uint256 ticketPriceInWei;
        uint256 endTime;
        NaffleType naffleType;
    }

    enum NaffleStatus {
        ACTIVE,
        POSTPONED,
        CANCELLED,
        SELECTING_WINNER,
        FINISHED
    }

    enum NaffleType {
        STANDARD,
        UNLIMITED
    }

    enum TicketType {
        OPEN_ENTRY,
        PAID
    }

    enum TokenContractType {
        ERC721,
        ERC1155,
        ERC20
    }

    struct NaffleTokenInformation {
        address tokenAddress;
        uint256 nftId;
        uint256 amount;
        TokenContractType naffleTokenType;
    }

    struct L1Naffle {
        NaffleTokenInformation naffleTokenInformation;
        uint256 naffleId;
        address owner;
        address winner;
        bool cancelled;
    }

    struct OpenEntryTicket {
        uint256 naffleId;
        uint256 ticketIdOnNaffle;
    }


    struct L2Naffle {
        NaffleTokenInformation naffleTokenInformation;
        address owner;
        uint256 naffleId;
        uint256 paidTicketSpots;
        uint256 openEntryTicketSpots;
        uint256 numberOfPaidTickets;
        uint256 numberOfOpenEntries;
        uint256 ticketPriceInWei;
        uint256 endTime;
        uint256 winningTicketId;
        NaffleStatus status;
        NaffleType naffleType;
    }
}

