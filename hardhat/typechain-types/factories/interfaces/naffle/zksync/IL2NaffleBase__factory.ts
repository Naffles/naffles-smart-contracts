/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IL2NaffleBase,
  IL2NaffleBaseInterface,
} from "../../../../interfaces/naffle/zksync/IL2NaffleBase";

const _abi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_naffleId",
        type: "uint256",
      },
    ],
    name: "buyTickets",
    outputs: [
      {
        internalType: "uint256[]",
        name: "ticketIds",
        type: "uint256[]",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        components: [
          {
            internalType: "address",
            name: "ethTokenAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "owner",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "naffleId",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "nftId",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "paidTicketSpots",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "ticketPriceInWei",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "endTime",
            type: "uint256",
          },
          {
            internalType: "enum NaffleTypes.NaffleType",
            name: "naffleType",
            type: "uint8",
          },
          {
            internalType: "enum NaffleTypes.TokenContractType",
            name: "naffleTokenType",
            type: "uint8",
          },
        ],
        internalType: "struct NaffleTypes.CreateZkSyncNaffleParams",
        name: "_params",
        type: "tuple",
      },
    ],
    name: "createNaffle",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_naffleId",
        type: "uint256",
      },
    ],
    name: "drawWinner",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_naffleId",
        type: "uint256",
      },
    ],
    name: "ownerCancelNaffle",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_naffleId",
        type: "uint256",
      },
    ],
    name: "ownerDrawWinner",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_naffleId",
        type: "uint256",
      },
      {
        internalType: "uint256[]",
        name: "_openEntryTicketIds",
        type: "uint256[]",
      },
      {
        internalType: "uint256[]",
        name: "_paidTicketIds",
        type: "uint256[]",
      },
      {
        internalType: "address",
        name: "_owner",
        type: "address",
      },
    ],
    name: "refundTicketsForNaffle",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256[]",
        name: "_ticketIds",
        type: "uint256[]",
      },
      {
        internalType: "uint256",
        name: "_naffleId",
        type: "uint256",
      },
    ],
    name: "useOpenEntryTickets",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class IL2NaffleBase__factory {
  static readonly abi = _abi;
  static createInterface(): IL2NaffleBaseInterface {
    return new utils.Interface(_abi) as IL2NaffleBaseInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IL2NaffleBase {
    return new Contract(address, _abi, signerOrProvider) as IL2NaffleBase;
  }
}
