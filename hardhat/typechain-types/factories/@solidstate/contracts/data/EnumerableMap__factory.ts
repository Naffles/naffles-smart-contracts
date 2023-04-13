/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  EnumerableMap,
  EnumerableMapInterface,
} from "../../../../@solidstate/contracts/data/EnumerableMap";

const _abi = [
  {
    inputs: [],
    name: "EnumerableMap__IndexOutOfBounds",
    type: "error",
  },
  {
    inputs: [],
    name: "EnumerableMap__NonExistentKey",
    type: "error",
  },
] as const;

const _bytecode =
  "0x60566037600b82828239805160001a607314602a57634e487b7160e01b600052600060045260246000fd5b30600052607381538281f3fe73000000000000000000000000000000000000000030146080604052600080fdfea26469706673582212209e6ce32b30e8b8b9a1cf4e76c45ef24f611ea0f1b5f4efb799a9ef059e440fea64736f6c63430008110033";

type EnumerableMapConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: EnumerableMapConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class EnumerableMap__factory extends ContractFactory {
  constructor(...args: EnumerableMapConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<EnumerableMap> {
    return super.deploy(overrides || {}) as Promise<EnumerableMap>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): EnumerableMap {
    return super.attach(address) as EnumerableMap;
  }
  override connect(signer: Signer): EnumerableMap__factory {
    return super.connect(signer) as EnumerableMap__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): EnumerableMapInterface {
    return new utils.Interface(_abi) as EnumerableMapInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): EnumerableMap {
    return new Contract(address, _abi, signerOrProvider) as EnumerableMap;
  }
}