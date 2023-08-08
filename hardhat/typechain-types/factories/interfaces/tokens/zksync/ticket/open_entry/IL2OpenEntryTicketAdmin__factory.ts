/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IL2OpenEntryTicketAdmin,
  IL2OpenEntryTicketAdminInterface,
} from "../../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketAdmin";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
    ],
    name: "adminMint",
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
        internalType: "string",
        name: "_baseURI",
        type: "string",
      },
    ],
    name: "setBaseURI",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_l2NaffleContractAddress",
        type: "address",
      },
    ],
    name: "setL2NaffleContractAddress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class IL2OpenEntryTicketAdmin__factory {
  static readonly abi = _abi;
  static createInterface(): IL2OpenEntryTicketAdminInterface {
    return new utils.Interface(_abi) as IL2OpenEntryTicketAdminInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IL2OpenEntryTicketAdmin {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as IL2OpenEntryTicketAdmin;
  }
}
