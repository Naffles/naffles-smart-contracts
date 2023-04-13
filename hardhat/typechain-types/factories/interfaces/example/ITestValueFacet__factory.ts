/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  ITestValueFacet,
  ITestValueFacetInterface,
} from "../../../interfaces/example/ITestValueFacet";

const _abi = [
  {
    inputs: [],
    name: "getValue",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "value",
        type: "string",
      },
    ],
    name: "setValue",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class ITestValueFacet__factory {
  static readonly abi = _abi;
  static createInterface(): ITestValueFacetInterface {
    return new utils.Interface(_abi) as ITestValueFacetInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ITestValueFacet {
    return new Contract(address, _abi, signerOrProvider) as ITestValueFacet;
  }
}