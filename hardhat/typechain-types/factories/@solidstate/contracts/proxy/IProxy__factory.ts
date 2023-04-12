/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IProxy,
  IProxyInterface,
} from "../../../../@solidstate/contracts/proxy/IProxy";

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

export class IProxy__factory {
  static readonly abi = _abi;
  static createInterface(): IProxyInterface {
    return new utils.Interface(_abi) as IProxyInterface;
  }
  static connect(address: string, signerOrProvider: Signer | Provider): IProxy {
    return new Contract(address, _abi, signerOrProvider) as IProxy;
  }
}
