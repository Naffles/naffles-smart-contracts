/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  L1NaffleView,
  L1NaffleViewInterface,
} from "../../../../contracts/naffle/ethereum/L1NaffleView";

const _abi = [
  {
    inputs: [],
    name: "FailedMessageInclusion",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "endTime",
        type: "uint256",
      },
    ],
    name: "InvalidEndTime",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "spots",
        type: "uint256",
      },
    ],
    name: "InvalidPaidTicketSpots",
    type: "error",
  },
  {
    inputs: [],
    name: "InvalidTokenType",
    type: "error",
  },
  {
    inputs: [],
    name: "MessageAlreadyProcessed",
    type: "error",
  },
  {
    inputs: [],
    name: "NotAllowed",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "naffleId",
        type: "uint256",
      },
    ],
    name: "L1NaffleCancelled",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "naffleId",
        type: "uint256",
      },
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "ethTokenAddress",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "nftId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "paidTicketSpots",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "ticketPriceInWei",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "endTime",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "enum NaffleTypes.NaffleType",
        name: "naffleType",
        type: "uint8",
      },
      {
        indexed: false,
        internalType: "enum NaffleTypes.TokenContractType",
        name: "tokenContractType",
        type: "uint8",
      },
    ],
    name: "L1NaffleCreated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "naffleId",
        type: "uint256",
      },
      {
        indexed: true,
        internalType: "address",
        name: "winner",
        type: "address",
      },
    ],
    name: "L1NaffleWinnerSet",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "bytes32",
        name: "previousAdminRole",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "bytes32",
        name: "newAdminRole",
        type: "bytes32",
      },
    ],
    name: "RoleAdminChanged",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "RoleGranted",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "RoleRevoked",
    type: "event",
  },
  {
    inputs: [],
    name: "getAdminRole",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getFoundersKeyAddress",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getFoundersKeyPlaceholderAddress",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getMinimumNaffleDuration",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getMinimumPaidTicketPriceInWei",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getMinimumPaidTicketSpots",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_id",
        type: "uint256",
      },
    ],
    name: "getNaffleById",
    outputs: [
      {
        components: [
          {
            internalType: "address",
            name: "tokenAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "nftId",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "naffleId",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "owner",
            type: "address",
          },
          {
            internalType: "address",
            name: "winner",
            type: "address",
          },
          {
            internalType: "bool",
            name: "cancelled",
            type: "bool",
          },
          {
            internalType: "enum NaffleTypes.TokenContractType",
            name: "naffleTokenType",
            type: "uint8",
          },
        ],
        internalType: "struct NaffleTypes.L1Naffle",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getZkSyncAddress",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getZkSyncNaffleContractAddress",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405234801561001057600080fd5b50610567806100206000396000f3fe608060405234801561001057600080fd5b50600436106100a35760003560e01c806345be4c5b11610076578063765c196e1161005b578063765c196e14610128578063b3ecf23614610130578063d42d54d01461013757600080fd5b806345be4c5b1461011857806368ee5b0a1461012057600080fd5b80630c8dca98146100a85780632995e4d1146100da5780632e152d5e146100fa5780633c4e709814610102575b600080fd5b6100b061013f565b60405173ffffffffffffffffffffffffffffffffffffffff90911681526020015b60405180910390f35b6100ed6100e8366004610444565b610184565b6040516100d1919061048c565b6100b06101d0565b61010a610210565b6040519081526020016100d1565b6100b061023a565b61010a61027a565b61010a6102a4565b600061010a565b6100b06102ce565b600061017f7f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67bd5473ffffffffffffffffffffffffffffffffffffffff1690565b905090565b6101c16040805160e081018252600080825260208201819052918101829052606081018290526080810182905260a081018290529060c082015290565b6101ca8261030e565b92915050565b600061017f7f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67bc5473ffffffffffffffffffffffffffffffffffffffff1690565b600061017f7f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67c15490565b600061017f7f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67bb5473ffffffffffffffffffffffffffffffffffffffff1690565b600061017f7f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67c05490565b600061017f7f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67bf5490565b600061017f7f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67ba5473ffffffffffffffffffffffffffffffffffffffff1690565b61034b6040805160e081018252600080825260208201819052918101829052606081018290526080810182905260a081018290529060c082015290565b60008281527f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67c26020908152604091829020825160e081018452815473ffffffffffffffffffffffffffffffffffffffff9081168252600180840154948301949094526002830154948201949094526003820154841660608201526004820154938416608082015260ff7401000000000000000000000000000000000000000085048116151560a08301529093919260c0850192750100000000000000000000000000000000000000000090049091169081111561042a5761042a61045d565b600181111561043b5761043b61045d565b90525092915050565b60006020828403121561045657600080fd5b5035919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602160045260246000fd5b600060e08201905073ffffffffffffffffffffffffffffffffffffffff80845116835260208401516020840152604084015160408401528060608501511660608401528060808501511660808401525060a0830151151560a083015260c083015160028110610524577f4e487b7100000000000000000000000000000000000000000000000000000000600052602160045260246000fd5b8060c0840152509291505056fea26469706673582212201becbeedcaefecd8b019abc10a4dde5e82033ef31633da412e640e5af2e6623d64736f6c63430008110033";

type L1NaffleViewConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: L1NaffleViewConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class L1NaffleView__factory extends ContractFactory {
  constructor(...args: L1NaffleViewConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<L1NaffleView> {
    return super.deploy(overrides || {}) as Promise<L1NaffleView>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): L1NaffleView {
    return super.attach(address) as L1NaffleView;
  }
  override connect(signer: Signer): L1NaffleView__factory {
    return super.connect(signer) as L1NaffleView__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): L1NaffleViewInterface {
    return new utils.Interface(_abi) as L1NaffleViewInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): L1NaffleView {
    return new Contract(address, _abi, signerOrProvider) as L1NaffleView;
  }
}
