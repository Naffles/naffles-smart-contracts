/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IL2PaidTicketBase,
  IL2PaidTicketBaseInterface,
} from "../../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBase";

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
      {
        internalType: "uint256",
        name: "_naffleId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "ticketPriceInWei",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "startingTicketId",
        type: "uint256",
      },
    ],
    name: "mintTickets",
    outputs: [
      {
        internalType: "uint256[]",
        name: "ticketIds",
        type: "uint256[]",
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
        name: "_naffleTicketIds",
        type: "uint256[]",
      },
      {
        internalType: "address",
        name: "_owner",
        type: "address",
      },
    ],
    name: "refundAndBurnTickets",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class IL2PaidTicketBase__factory {
  static readonly abi = _abi;
  static createInterface(): IL2PaidTicketBaseInterface {
    return new utils.Interface(_abi) as IL2PaidTicketBaseInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IL2PaidTicketBase {
    return new Contract(address, _abi, signerOrProvider) as IL2PaidTicketBase;
  }
}
