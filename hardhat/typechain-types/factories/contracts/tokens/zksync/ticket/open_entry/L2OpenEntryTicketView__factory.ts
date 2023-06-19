/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../../../common";
import type {
  L2OpenEntryTicketView,
  L2OpenEntryTicketViewInterface,
} from "../../../../../../contracts/tokens/zksync/ticket/open_entry/L2OpenEntryTicketView";

const _abi = [
  {
    inputs: [],
    name: "ERC721Base__BalanceQueryZeroAddress",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__ERC721ReceiverNotImplemented",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__InvalidOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__MintToZeroAddress",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__NonExistentToken",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__NotOwnerOrApproved",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__NotTokenOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__SelfApproval",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__TokenAlreadyMinted",
    type: "error",
  },
  {
    inputs: [],
    name: "ERC721Base__TransferToZeroAddress",
    type: "error",
  },
  {
    inputs: [],
    name: "EnumerableMap__NonExistentKey",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "ticketId",
        type: "uint256",
      },
    ],
    name: "InvalidTicketId",
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
    name: "NaffleNotCancelled",
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
        name: "ticketId",
        type: "uint256",
      },
    ],
    name: "NotOwnerOfTicket",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "NotTicketOwner",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "ticketId",
        type: "uint256",
      },
    ],
    name: "TicketAlreadyUsed",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
    ],
    name: "ApprovalForAll",
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
        indexed: false,
        internalType: "uint256[]",
        name: "ticketIds",
        type: "uint256[]",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "startingTicketId",
        type: "uint256",
      },
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
    ],
    name: "TicketsAttachedToNaffle",
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
        internalType: "uint256[]",
        name: "ticketIds",
        type: "uint256[]",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "ticketIdsOnNaffle",
        type: "uint256[]",
      },
    ],
    name: "TicketsDetachedFromNaffle",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Transfer",
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
    name: "getL2NaffleContractAddress",
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
    inputs: [
      {
        internalType: "uint256",
        name: "_ticketId",
        type: "uint256",
      },
    ],
    name: "getOpenEntryTicketById",
    outputs: [
      {
        components: [
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
        internalType: "struct NaffleTypes.OpenEntryTicket",
        name: "",
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
        name: "",
        type: "address",
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
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

const _bytecode =
  "0x0002000000000002000100000000000200010000000103550000006001100270000000550010019d0000008001000039000000400010043f0000000101200190000000320000c13d0000000001000031000000040110008c000000ef0000413d0000000101000367000000000101043b000000e001100270000000570210009c0000003a0000a13d000000580210009c0000008b0000613d000000590210009c000000c50000613d0000005a0110009c000000ef0000c13d0000000001000416000000000110004c000000ef0000c13d000000040100008a00000000011000310000005d02000041000000000310004c000000000300001900000000030240190000005d01100197000000000410004c000000000200a0190000005d0110009c00000000010300190000000001026019000000000110004c000000ef0000c13d0000005e01000041000000000101041a000000400200043d00000000001204350000005501000041000000550320009c000000000102401900000040011002100000005f011001c70000014e0001042e0000000001000416000000000110004c000000ef0000c13d00000020010000390000010000100443000001200000044300000056010000410000014e0001042e0000005b0210009c000000de0000613d0000005c0110009c000000ef0000c13d0000000001000416000000000110004c000000ef0000c13d000000040100008a00000000011000310000005d02000041000000400310008c000000000300001900000000030240190000005d01100197000000000410004c000000000200a0190000005d0110009c00000000010300190000000001026019000000000110004c000000ef0000c13d00000004010000390000000101100367000000000101043b00000000001004350000006201000041000000200010043f00000055010000410000000002000414000000550320009c0000000001024019000000c00110021000000063011001c70000801002000039014d01480000040f0000000102200190000000ef0000613d000000000101043b00000024020000390000000102200367000000000202043b0000000000200435000000200010043f00000055010000410000000002000414000000550320009c0000000001024019000000c00110021000000063011001c70000801002000039014d01480000040f0000000102200190000000ef0000613d000000000101043b000000000101041a00000000001004350000006401000041000000200010043f00000055010000410000000002000414000000550320009c0000000001024019000000c00110021000000063011001c70000801002000039014d01480000040f0000000102200190000000ef0000613d000000000101043b000000000101041a000000000210004c000000f70000c13d000000400100043d0000006b0200004100000000002104350000005502000041000000550310009c000000000102801900000040011002100000006a011001c70000014f000104300000000001000416000000000110004c000000ef0000c13d000000040100008a00000000011000310000005d02000041000000200310008c000000000300001900000000030240190000005d01100197000000000410004c000000000200a0190000005d0110009c00000000010300190000000001026019000000000110004c000000ef0000c13d014d01370000040f014d01370000040f00000004010000390000000101100367000000000101043b00000000001004350000006001000041000000200010043f0000000001000019014d01190000040f000100000001001d014d012b0000040f0000000105000029000000000205041a00000000032104360000000104500039000000000404041a000000000043043500000040011000390000000204500039000000000404041a000000ff044001900000000004000019000000010400c0390000000000410435000000400400043d0000000002240436000000000303043300000000003204350000000001010433000000000110004c0000000001000019000000010100c039000000400240003900000000001204350000005501000041000000550240009c0000000001044019000000400110021000000061011001c70000014e0001042e0000000001000416000000000110004c000000ef0000c13d000000040100008a00000000011000310000005d02000041000000000310004c000000000300001900000000030240190000005d01100197000000000410004c000000000200a0190000005d0110009c00000000010300190000000001026019000000000110004c000000ef0000c13d000000400100043d00000000000104350000005502000041000000550310009c000000000102801900000040011002100000005f011001c70000014e0001042e0000000001000416000000000110004c000000ef0000c13d000000040100008a00000000011000310000005d02000041000000000310004c000000000300001900000000030240190000005d01100197000000000410004c000000000200a0190000005d0110009c00000000010300190000000001026019000000000110004c000000f10000613d00000000010000190000014f000104300000006c01000041000000000101041a0000006801100197000000800010043f0000006d010000410000014e0001042e000000010210008a0000005e01000041000000000101041a000000000112004b0000010c0000813d0000005e010000410000000000100435000000400100043d00000001022002100000006702200041000000000202041a0000006802200198000001120000c13d000000690200004100000000002104350000005502000041000000550310009c000000000102801900000040011002100000006a011001c70000014f00010430000000650100004100000000001004350000003201000039000000040010043f00000066010000410000014f0001043000000000002104350000005502000041000000550310009c000000000102801900000040011002100000005f011001c70000014e0001042e00000055020000410000000003000414000000550430009c0000000003028019000000550410009c00000000010280190000004001100210000000c002300210000000000112019f00000063011001c70000801002000039014d01480000040f0000000102200190000001290000613d000000000101043b000000000001042d00000000010000190000014f00010430000000400100043d0000006e0210009c000001310000813d0000006002100039000000400020043f000000000001042d000000650100004100000000001004350000004101000039000000040010043f00000066010000410000014f00010430000000400100043d0000006e0210009c000001420000813d0000006002100039000000400020043f00000040021000390000000000020435000000200210003900000000000204350000000000010435000000000001042d000000650100004100000000001004350000004101000039000000040010043f00000066010000410000014f000104300000014b002104230000000102000039000000000001042d0000000002000019000000000001042d0000014d000004320000014e0001042e0000014f00010430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000002000000000000000000000000000000400000010000000000000000000000000000000000000000000000000000000000000000000000000095c95a9c0000000000000000000000000000000000000000000000000000000095c95a9d00000000000000000000000000000000000000000000000000000000b3ecf23600000000000000000000000000000000000000000000000000000000c4e41b22000000000000000000000000000000000000000000000000000000000ec01a67000000000000000000000000000000000000000000000000000000006b9dc11a80000000000000000000000000000000000000000000000000000000000000003c7bf052874fa81625121783266a03507bd2cd48b16e571c01a04e8dd3fb07a600000000000000000000000000000000000000200000000000000000000000001711c63114197c394f54d5497ead4a5b8cd22ec97e5359f1583e739cfb54a5fa00000000000000000000000000000000000000600000000000000000000000001711c63114197c394f54d5497ead4a5b8cd22ec97e5359f1583e739cfb54a5f802000000000000000000000000000000000000400000000000000000000000003c7bf052874fa81625121783266a03507bd2cd48b16e571c01a04e8dd3fb07a74e487b71000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000024000000000000000000000000709a16c9caeafb61409212be896356f281c91d5c5b5cccb959477d20bb6240fc000000000000000000000000ffffffffffffffffffffffffffffffffffffffff7e1a7d8b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000f551fb14000000000000000000000000000000000000000000000000000000001711c63114197c394f54d5497ead4a5b8cd22ec97e5359f1583e739cfb54a5f70000000000000000000000000000000000000020000000800000000000000000000000000000000000000000000000000000000000000000ffffffffffffffa000000000000000000000000000000000000000000000000000000000000000000e97152d3004ac435acc3b92df17cf4bce7dab6da4b0da86e192abfbb10a2519";

type L2OpenEntryTicketViewConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: L2OpenEntryTicketViewConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class L2OpenEntryTicketView__factory extends ContractFactory {
  constructor(...args: L2OpenEntryTicketViewConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<L2OpenEntryTicketView> {
    return super.deploy(overrides || {}) as Promise<L2OpenEntryTicketView>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): L2OpenEntryTicketView {
    return super.attach(address) as L2OpenEntryTicketView;
  }
  override connect(signer: Signer): L2OpenEntryTicketView__factory {
    return super.connect(signer) as L2OpenEntryTicketView__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): L2OpenEntryTicketViewInterface {
    return new utils.Interface(_abi) as L2OpenEntryTicketViewInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): L2OpenEntryTicketView {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as L2OpenEntryTicketView;
  }
}
