// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

library NaffleTypes {
    struct L2MessageParams {
        uint256 l2GasLimit;
        uint256 l2GasPerPubdataByteLimit;
    }

    struct ExchangeRateData {
        uint256 exchangeRate;
        uint256 expireTimestamp;
    }

    struct ExchangeRateParams {
        ExchangeRateData exchangeRateData;
        bytes exchangeRateSignature;
    }

    struct CollectionWhitelistParams {
        uint256 expiresAt;
        bytes signature;
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

    enum ActionType {
        SET_WINNER,
        CANCEL
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

    enum TxStatus {
        Failure,
        Success
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
        bytes32 txHash;
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

