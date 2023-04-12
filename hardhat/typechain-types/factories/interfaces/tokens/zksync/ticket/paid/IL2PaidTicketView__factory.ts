/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IL2PaidTicketView,
  IL2PaidTicketViewInterface,
} from "../../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketView";

const _abi = [
  {
    inputs: [],
    name: "getAdminRole",
    outputs: [
      {
        internalType: "bytes32",
        name: "adminRole",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getL2NaffleContractAddress",
    outputs: [
      {
        internalType: "address",
        name: "l2NaffleContractAddress",
        type: "address",
      },
    ],
    stateMutability: "view",
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
        internalType: "uint256",
        name: "_ticketIdOnNaffle",
        type: "uint256",
      },
    ],
    name: "getOwnerOfNaffleTicketId",
    outputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_ticketId",
        type: "uint256",
      },
    ],
    name: "getTicketById",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "ticketPriceInWei",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "naffleId",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "ticketIdOnNaffle",
            type: "uint256",
          },
          {
            internalType: "bool",
            name: "winningTicket",
            type: "bool",
          },
        ],
        internalType: "struct NaffleTypes.PaidTicket",
        name: "ticket",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_ticketIdOnNaffle",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_naffleId",
        type: "uint256",
      },
    ],
    name: "getTicketByIdOnNaffle",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "ticketPriceInWei",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "naffleId",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "ticketIdOnNaffle",
            type: "uint256",
          },
          {
            internalType: "bool",
            name: "winningTicket",
            type: "bool",
          },
        ],
        internalType: "struct NaffleTypes.PaidTicket",
        name: "ticket",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getTotalSupply",
    outputs: [
      {
        internalType: "uint256",
        name: "totalSupply",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

export class IL2PaidTicketView__factory {
  static readonly abi = _abi;
  static createInterface(): IL2PaidTicketViewInterface {
    return new utils.Interface(_abi) as IL2PaidTicketViewInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IL2PaidTicketView {
    return new Contract(address, _abi, signerOrProvider) as IL2PaidTicketView;
  }
}
