/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  L2NaffleView,
  L2NaffleViewInterface,
} from "../../../../contracts/naffle/zksync/L2NaffleView";

const _abi = [
  {
    inputs: [],
    name: "InsufficientFunds",
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
        name: "naffleId",
        type: "uint256",
      },
    ],
    name: "InvalidNaffleId",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "enum NaffleTypes.NaffleStatus",
        name: "status",
        type: "uint8",
      },
    ],
    name: "InvalidNaffleStatus",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "enum NaffleTypes.NaffleType",
        name: "naffleType",
        type: "uint8",
      },
    ],
    name: "InvalidNaffleType",
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
    name: "NaffleNotEndedYet",
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
    name: "NaffleNotFinished",
    type: "error",
  },
  {
    inputs: [],
    name: "NaffleSoldOut",
    type: "error",
  },
  {
    inputs: [],
    name: "NoTicketsBought",
    type: "error",
  },
  {
    inputs: [],
    name: "NotAllowed",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "NotEnoughFunds",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "NotEnoughOpenEntryTicketSpots",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "NotEnoughPaidTicketSpots",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
    ],
    name: "NotNaffleOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "OpenTicketRatioCannotBeZero",
    type: "error",
  },
  {
    inputs: [],
    name: "UnableToSendFunds",
    type: "error",
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
        indexed: false,
        internalType: "bytes32",
        name: "messageHash",
        type: "bytes32",
      },
    ],
    name: "L2NaffleCancelled",
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
        name: "freeTicketSpots",
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
        indexed: true,
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
    name: "L2NaffleCreated",
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
        indexed: false,
        internalType: "address",
        name: "winner",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "winningTicketIdOnNaffle",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "messageHash",
        type: "bytes32",
      },
    ],
    name: "L2NaffleFinished",
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
        name: "owner",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "ticketIds",
        type: "uint256[]",
      },
    ],
    name: "OpenEntryTicketsUsed",
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
        name: "buyer",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "ticketIds",
        type: "uint256[]",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "ticketPriceInWei",
        type: "uint256",
      },
    ],
    name: "TicketsBought",
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
    name: "getL1NaffleContractAddress",
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
    name: "getMaxPostponeTime",
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
            name: "ethTokenAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "owner",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "naffleId",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "nftId",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "paidTicketSpots",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "openEntryTicketSpots",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "numberOfPaidTickets",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "numberOfOpenEntries",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "ticketPriceInWei",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "endTime",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "winningTicketId",
            type: "uint256",
          },
          {
            internalType: "enum NaffleTypes.TicketType",
            name: "winningTicketType",
            type: "uint8",
          },
          {
            internalType: "enum NaffleTypes.NaffleStatus",
            name: "status",
            type: "uint8",
          },
          {
            internalType: "enum NaffleTypes.TokenContractType",
            name: "naffleTokenType",
            type: "uint8",
          },
          {
            internalType: "enum NaffleTypes.NaffleType",
            name: "naffleType",
            type: "uint8",
          },
        ],
        internalType: "struct NaffleTypes.L2Naffle",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getOpenEntryRatio",
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
    name: "getOpenEntryTicketContractAddress",
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
    name: "getPaidTicketContractAddress",
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
    name: "getPlatformFee",
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
] as const;

const _bytecode =
  "0x00020000000000020002000000000002000100000001035500000060011002700000007c0010019d0000008001000039000000400010043f0000000101200190000000530000c13d0000000001000031000000040110008c0000011a0000413d0000000101000367000000000101043b000000e0011002700000007e0210009c0000005b0000213d000000840210009c0000007c0000213d000000870210009c000000ba0000613d000000880110009c0000011a0000c13d0000000001000416000000000110004c0000011a0000c13d000000040100008a00000000011000310000008902000041000000200310008c000000000300001900000000030240190000008901100197000000000410004c000000000200a019000000890110009c00000000010300190000000001026019000000000110004c0000011a0000c13d000000400100043d000000910210009c0000004d0000813d000001e002100039000000400020043f000001c0021000390000000000020435000001a00210003900000000000204350000018002100039000000000002043500000160021000390000000000020435000001400210003900000000000204350000012002100039000000000002043500000100021000390000000000020435000000e0021000390000000000020435000000c0021000390000000000020435000000a0021000390000000000020435000000800210003900000000000204350000006002100039000000000002043500000040021000390000000000020435000000200210003900000000000204350000000000010435000000400100043d000000920210009c000001240000a13d000000960100004100000000001004350000004101000039000000040010043f0000009701000041000001eb000104300000000001000416000000000110004c0000011a0000c13d0000002001000039000001000010044300000120000004430000007d01000041000001ea0001042e0000007f0210009c0000009b0000213d000000820210009c000000d10000613d000000830110009c0000011a0000c13d0000000001000416000000000110004c0000011a0000c13d000000040100008a00000000011000310000008902000041000000000310004c000000000300001900000000030240190000008901100197000000000410004c000000000200a019000000890110009c00000000010300190000000001026019000000000110004c0000011a0000c13d0000008c01000041000000000101041a000000400200043d00000000001204350000007c010000410000007c0320009c000000000102401900000040011002100000008b011001c7000001ea0001042e000000850210009c000000ed0000613d000000860110009c0000011a0000c13d0000000001000416000000000110004c0000011a0000c13d000000040100008a00000000011000310000008902000041000000000310004c000000000300001900000000030240190000008901100197000000000410004c000000000200a019000000890110009c00000000010300190000000001026019000000000110004c0000011a0000c13d0000008f01000041000000000101041a000000400200043d00000000001204350000007c010000410000007c0320009c000000000102401900000040011002100000008b011001c7000001ea0001042e000000800210009c000001090000613d000000810110009c0000011a0000c13d0000000001000416000000000110004c0000011a0000c13d000000040100008a00000000011000310000008902000041000000000310004c000000000300001900000000030240190000008901100197000000000410004c000000000200a019000000890110009c00000000010300190000000001026019000000000110004c0000011a0000c13d0000008a01000041000000000101041a000000400200043d00000000001204350000007c010000410000007c0320009c000000000102401900000040011002100000008b011001c7000001ea0001042e0000000001000416000000000110004c0000011a0000c13d000000040100008a00000000011000310000008902000041000000000310004c000000000300001900000000030240190000008901100197000000000410004c000000000200a019000000890110009c00000000010300190000000001026019000000000110004c0000011a0000c13d0000009801000041000000000101041a0000008e01100197000000800010043f0000009901000041000001ea0001042e0000000001000416000000000110004c0000011a0000c13d000000040100008a00000000011000310000008902000041000000000310004c000000000300001900000000030240190000008901100197000000000410004c000000000200a019000000890110009c00000000010300190000000001026019000000000110004c0000011a0000c13d0000008d01000041000000000101041a0000008e01100197000000400200043d00000000001204350000007c010000410000007c0320009c000000000102401900000040011002100000008b011001c7000001ea0001042e0000000001000416000000000110004c0000011a0000c13d000000040100008a00000000011000310000008902000041000000000310004c000000000300001900000000030240190000008901100197000000000410004c000000000200a019000000890110009c00000000010300190000000001026019000000000110004c0000011a0000c13d0000009001000041000000000101041a0000008e01100197000000400200043d00000000001204350000007c010000410000007c0320009c000000000102401900000040011002100000008b011001c7000001ea0001042e0000000001000416000000000110004c0000011a0000c13d000000040100008a00000000011000310000008902000041000000000310004c000000000300001900000000030240190000008901100197000000000410004c000000000200a019000000890110009c00000000010300190000000001026019000000000110004c0000011c0000613d0000000001000019000001eb00010430000000400100043d00000000000104350000007c020000410000007c0310009c000000000102801900000040011002100000008b011001c7000001ea0001042e000001e002100039000000400020043f000001c0021000390000000000020435000001a00210003900000000000204350000018002100039000000000002043500000160021000390000000000020435000001400210003900000000000204350000012002100039000000000002043500000100021000390000000000020435000000e0021000390000000000020435000000c0021000390000000000020435000000a002100039000000000002043500000080021000390000000000020435000000600210003900000000000204350000004002100039000000000002043500000020021000390000000000020435000000000001043500000004010000390000000101100367000000000101043b00000000001004350000009301000041000000200010043f0000007c0100004100000000020004140000007c0320009c0000000001024019000000c00110021000000094011001c7000080100200003901e901e40000040f00000001022001900000011a0000613d000000400200043d000000920320009c0000004d0000213d000000000c01043b000001e001200039000000400010043f00000000010c041a0000008e0110019700000000011204360000000103c00039000000000303041a0000008e0330019700000000003104350000000203c00039000000000403041a000000400320003900000000004304350000000304c00039000000000504041a000000600420003900000000005404350000000405c00039000000000605041a000000800520003900000000006504350000000506c00039000000000706041a000000a00620003900000000007604350000000607c00039000000000807041a000000c00720003900000000008704350000000708c00039000000000908041a000000e00820003900000000009804350000000809c00039000000000a09041a00000100092000390000000000a90435000000090ac00039000000000a0a041a000001200b2000390000000000ab0435000001400a2000390000000a0dc00039000000000d0d041a0000000000da04350000000b0cc00039000000000f0c041a000000ff0df0018f000000030cd0008c000001d60000813d000001600c2000390000000000dc04350000ff000df0018f000004ff0dd0008c000001d60000213d000001800d200039000000080ef00270000000ff0ee0018f00020000000d001d0000000000ed0435000000100ef00270000000ff0ee0018f000000010de0008c000001d60000213d000001a00d20003900010000000d001d0000000000ed0435000000180df00270000000ff0ed0018f000000010de0008c000001d60000213d000001c00f2000390000000000ef043500000000020204330000008e0d200197000000400200043d000000000dd2043600000000010104330000008e0110019700000000001d04350000000001030433000000400320003900000000001304350000000001040433000000600320003900000000001304350000000001050433000000800320003900000000001304350000000001060433000000a00320003900000000001304350000000001070433000000c00320003900000000001304350000000001080433000000e003200039000000000013043500000000010904330000010003200039000000000013043500000000010b04330000012003200039000000000013043500000000010a04330000014003200039000000000013043500000000010c0433000000020310008c000001d60000213d0000016003200039000000000013043500000002010000290000000001010433000000040310008c000001d60000213d0000018003200039000000000013043500000001010000290000000001010433000000010310008c000001d60000213d000001a003200039000000000013043500000000010f0433000000010310008c000001dc0000a13d000000960100004100000000001004350000002101000039000000040010043f0000009701000041000001eb00010430000001c00320003900000000001304350000007c010000410000007c0320009c0000000001024019000000400110021000000095011001c7000001ea0001042e000001e7002104230000000102000039000000000001042d0000000002000019000000000001042d000001e900000432000001ea0001042e000001eb00010430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000200000000000000000000000000000040000001000000000000000000000000000000000000000000000000000000000000000000000000006b0c47bc00000000000000000000000000000000000000000000000000000000b3ecf23500000000000000000000000000000000000000000000000000000000b3ecf23600000000000000000000000000000000000000000000000000000000c7f6265f000000000000000000000000000000000000000000000000000000006b0c47bd000000000000000000000000000000000000000000000000000000006ea8bc10000000000000000000000000000000000000000000000000000000004025572e000000000000000000000000000000000000000000000000000000004025572f000000000000000000000000000000000000000000000000000000006497dd1a000000000000000000000000000000000000000000000000000000001b1572e5000000000000000000000000000000000000000000000000000000002995e4d1800000000000000000000000000000000000000000000000000000000000000002c0f6ea35402fd9c5779ec907d98e3386cbf20055e86ccc8f3265ae1f5065a2000000000000000000000000000000000000002000000000000000000000000002c0f6ea35402fd9c5779ec907d98e3386cbf20055e86ccc8f3265ae1f5065a302c0f6ea35402fd9c5779ec907d98e3386cbf20055e86ccc8f3265ae1f5065a1000000000000000000000000ffffffffffffffffffffffffffffffffffffffff02c0f6ea35402fd9c5779ec907d98e3386cbf20055e86ccc8f3265ae1f5065a402c0f6ea35402fd9c5779ec907d98e3386cbf20055e86ccc8f3265ae1f50659e000000000000000000000000000000000000000000000000fffffffffffffe20000000000000000000000000000000000000000000000000fffffffffffffe1f02c0f6ea35402fd9c5779ec907d98e3386cbf20055e86ccc8f3265ae1f5065a5020000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000001e00000000000000000000000004e487b7100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002400000000000000000000000002c0f6ea35402fd9c5779ec907d98e3386cbf20055e86ccc8f3265ae1f5065a000000000000000000000000000000000000000200000008000000000000000009bb744e32dc2966c193ba9029afd6242cde34da51fd6e5d846c0890464bed0cd";

type L2NaffleViewConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: L2NaffleViewConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class L2NaffleView__factory extends ContractFactory {
  constructor(...args: L2NaffleViewConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<L2NaffleView> {
    return super.deploy(overrides || {}) as Promise<L2NaffleView>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): L2NaffleView {
    return super.attach(address) as L2NaffleView;
  }
  override connect(signer: Signer): L2NaffleView__factory {
    return super.connect(signer) as L2NaffleView__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): L2NaffleViewInterface {
    return new utils.Interface(_abi) as L2NaffleViewInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): L2NaffleView {
    return new Contract(address, _abi, signerOrProvider) as L2NaffleView;
  }
}
