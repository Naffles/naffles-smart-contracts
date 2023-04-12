/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  DiamondBase,
  DiamondBaseInterface,
} from "../../../../../../@solidstate/contracts/proxy/diamond/base/DiamondBase";

const _abi = [
  {
    inputs: [],
    name: "Proxy__ImplementationIsNotContract",
    type: "error",
  },
  {
    stateMutability: "payable",
    type: "fallback",
  },
] as const;

export class DiamondBase__factory {
  static readonly abi = _abi;
  static createInterface(): DiamondBaseInterface {
    return new utils.Interface(_abi) as DiamondBaseInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): DiamondBase {
    return new Contract(address, _abi, signerOrProvider) as DiamondBase;
  }
}
