/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  L1MessengerMock,
  L1MessengerMockInterface,
} from "../../../../contracts/mocks/zksync/L1MessengerMock";

const _abi = [
  {
    inputs: [],
    name: "NotAllowed",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "_sender",
        type: "address",
      },
      {
        indexed: true,
        internalType: "bytes32",
        name: "_hash",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "bytes",
        name: "_message",
        type: "bytes",
      },
    ],
    name: "L1MessageSent",
    type: "event",
  },
  {
    inputs: [],
    name: "called",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes",
        name: "_message",
        type: "bytes",
      },
    ],
    name: "sendToL1",
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
] as const;

const _bytecode =
  "0x60806040526000805460ff1916905534801561001a57600080fd5b506101dc8061002a6000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c806350f9b6cd1461003b57806362f84b241461005d575b600080fd5b6000546100489060ff1681565b60405190151581526020015b60405180910390f35b61009a61006b3660046100d7565b50600080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0016600117815590565b604051908152602001610054565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6000602082840312156100e957600080fd5b813567ffffffffffffffff8082111561010157600080fd5b818401915084601f83011261011557600080fd5b813581811115610127576101276100a8565b604051601f82017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0908116603f0116810190838211818310171561016d5761016d6100a8565b8160405282815287602084870101111561018657600080fd5b82602086016020830137600092810160200192909252509594505050505056fea26469706673582212200fd133c44dd6f9d2b27c31da9ab0233361c308131ebca049c07986ca8a99277e64736f6c63430008110033";

type L1MessengerMockConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: L1MessengerMockConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class L1MessengerMock__factory extends ContractFactory {
  constructor(...args: L1MessengerMockConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<L1MessengerMock> {
    return super.deploy(overrides || {}) as Promise<L1MessengerMock>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): L1MessengerMock {
    return super.attach(address) as L1MessengerMock;
  }
  override connect(signer: Signer): L1MessengerMock__factory {
    return super.connect(signer) as L1MessengerMock__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): L1MessengerMockInterface {
    return new utils.Interface(_abi) as L1MessengerMockInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): L1MessengerMock {
    return new Contract(address, _abi, signerOrProvider) as L1MessengerMock;
  }
}
