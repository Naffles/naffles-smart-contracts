/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IL2OpenEntryTicketBaseInternal,
  IL2OpenEntryTicketBaseInternalInterface,
} from "../../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBaseInternal";

const _abi = [
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
] as const;

export class IL2OpenEntryTicketBaseInternal__factory {
  static readonly abi = _abi;
  static createInterface(): IL2OpenEntryTicketBaseInternalInterface {
    return new utils.Interface(_abi) as IL2OpenEntryTicketBaseInternalInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IL2OpenEntryTicketBaseInternal {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as IL2OpenEntryTicketBaseInternal;
  }
}
