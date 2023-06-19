/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  L2OpenEntryTicketBaseInternal,
  L2OpenEntryTicketBaseInternalInterface,
} from "../../../../../../contracts/tokens/zksync/ticket/open_entry/L2OpenEntryTicketBaseInternal";

const _abi = [
  {
    inputs: [],
    name: "ERC721Base__BalanceQueryZeroAddress",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__ERC721ReceiverNotImplemented",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__InvalidOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__MintToZeroAddress",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__NonExistentToken",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__NotOwnerOrApproved",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__NotTokenOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__SelfApproval",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__TokenAlreadyMinted",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__TransferToZeroAddress",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "ticketId",
        type: "uint256",
      },
    ],
    name: "InvalidTicketId",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "enum NaffleTypes.NaffleStatus",
        name: "status",
        type: "uint8",
      },
    ],
    name: "NaffleNotCancelled",
    type: "error",
  },
  {
    inputs: [],
    name: "NotAllowed",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "ticketId",
        type: "uint256",
      },
    ],
    name: "NotOwnerOfTicket",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "NotTicketOwner",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "ticketId",
        type: "uint256",
      },
    ],
    name: "TicketAlreadyUsed",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
    ],
    name: "ApprovalForAll",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "bytes32",
        name: "previousAdminRole",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "bytes32",
        name: "newAdminRole",
        type: "bytes32",
      },
    ],
    name: "RoleAdminChanged",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "RoleGranted",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "RoleRevoked",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "naffleId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "ticketIds",
        type: "uint256[]",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "startingTicketId",
        type: "uint256",
      },
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
    ],
    name: "TicketsAttachedToNaffle",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "naffleId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "ticketIds",
        type: "uint256[]",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "ticketIdsOnNaffle",
        type: "uint256[]",
      },
    ],
    name: "TicketsDetachedFromNaffle",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
] as const;

export class L2OpenEntryTicketBaseInternal__factory {
  static readonly abi = _abi;
  static createInterface(): L2OpenEntryTicketBaseInternalInterface {
    return new utils.Interface(_abi) as L2OpenEntryTicketBaseInternalInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): L2OpenEntryTicketBaseInternal {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as L2OpenEntryTicketBaseInternal;
  }
}
