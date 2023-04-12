/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  ISoulboundFoundersKey,
  ISoulboundFoundersKeyInterface,
} from "../../interfaces/ISoulboundFoundersKey";

const _abi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "safeMint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class ISoulboundFoundersKey__factory {
  static readonly abi = _abi;
  static createInterface(): ISoulboundFoundersKeyInterface {
    return new utils.Interface(_abi) as ISoulboundFoundersKeyInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ISoulboundFoundersKey {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as ISoulboundFoundersKey;
  }
}
