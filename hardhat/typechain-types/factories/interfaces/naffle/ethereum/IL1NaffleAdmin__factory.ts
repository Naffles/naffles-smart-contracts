/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IL1NaffleAdmin,
  IL1NaffleAdminInterface,
} from "../../../../interfaces/naffle/ethereum/IL1NaffleAdmin";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_zkSyncAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_l2BlockNumber",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_index",
        type: "uint256",
      },
      {
        internalType: "uint16",
        name: "_l2TxNumberInBlock",
        type: "uint16",
      },
      {
        internalType: "bytes",
        name: "_message",
        type: "bytes",
      },
      {
        internalType: "bytes32[]",
        name: "_proof",
        type: "bytes32[]",
      },
    ],
    name: "consumeAdminCancelMessage",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_admin",
        type: "address",
      },
    ],
    name: "setAdmin",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_foundersKeyAddress",
        type: "address",
      },
    ],
    name: "setFoundersKeyAddress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_foundersKeyPlaceholderAddress",
        type: "address",
      },
    ],
    name: "setFoundersKeyPlaceholderAddress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_minimumNaffleDuration",
        type: "uint256",
      },
    ],
    name: "setMinimumNaffleDuration",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_minimumPaidTicketPriceInWei",
        type: "uint256",
      },
    ],
    name: "setMinimumPaidTicketPriceInWei",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_minimumPaidTicketSpots",
        type: "uint256",
      },
    ],
    name: "setMinimumPaidTicketSpots",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_zkSyncAddress",
        type: "address",
      },
    ],
    name: "setZkSyncAddress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_zkSyncNaffleContractAddress",
        type: "address",
      },
    ],
    name: "setZkSyncNaffleContractAddress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class IL1NaffleAdmin__factory {
  static readonly abi = _abi;
  static createInterface(): IL1NaffleAdminInterface {
    return new utils.Interface(_abi) as IL1NaffleAdminInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IL1NaffleAdmin {
    return new Contract(address, _abi, signerOrProvider) as IL1NaffleAdmin;
  }
}
