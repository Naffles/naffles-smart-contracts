/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../../../common";
import type {
  L2PaidTicketView,
  L2PaidTicketViewInterface,
} from "../../../../../../contracts/tokens/zksync/ticket/paid/L2PaidTicketView";

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
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "NotTicketOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "RefundFailed",
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
      {
        indexed: true,
        internalType: "uint256",
        name: "naffleId",
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
        name: "startingTicketId",
        type: "uint256",
      },
    ],
    name: "PaidTicketsMinted",
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
    name: "PaidTicketsRefundedAndBurned",
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
    inputs: [
      {
        internalType: "uint256",
        name: "_ticketId",
        type: "uint256",
      },
    ],
    name: "getTicketById",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "ticketPriceInWei",
            type: "uint256",
          },
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
        internalType: "struct NaffleTypes.PaidTicket",
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
        name: "_ticketIdOnNaffle",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_naffleId",
        type: "uint256",
      },
    ],
    name: "getTicketByIdOnNaffle",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "ticketPriceInWei",
            type: "uint256",
          },
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
        internalType: "struct NaffleTypes.PaidTicket",
        name: "",
        type: "tuple",
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
  "0x608060405234801561001057600080fd5b506105a4806100206000396000f3fe608060405234801561001057600080fd5b50600436106100725760003560e01c80636b9dc11a116100505780636b9dc11a14610104578063b3ecf23614610117578063c4e41b221461012857600080fd5b80630ec01a671461007757806327b7aabc146100a95780632844efac146100f1575b600080fd5b61007f610130565b60405173ffffffffffffffffffffffffffffffffffffffff90911681526020015b60405180910390f35b6100bc6100b7366004610504565b610175565b6040516100a0919081518152602080830151908201526040808301519082015260609182015115159181019190915260800190565b6100bc6100ff36600461051d565b6101b1565b61007f61011236600461051d565b6101ef565b60005b6040519081526020016100a0565b61011a6101fb565b60006101707f3d8a11862a15163ca73fa8d9e16d69918cd78af58fc339633e5f208633ff76705473ffffffffffffffffffffffffffffffffffffffff1690565b905090565b6101a260405180608001604052806000815260200160008152602001600081526020016000151581525090565b6101ab82610205565b92915050565b6101de60405180608001604052806000815260200160008152602001600081526020016000151581525090565b6101e8838361029b565b9392505050565b60006101e88383610363565b60006101706103cf565b61023260405180608001604052806000815260200160008152602001600081526020016000151581525090565b5060009081527f3d8a11862a15163ca73fa8d9e16d69918cd78af58fc339633e5f208633ff7672602090815260409182902082516080810184528154815260018201549281019290925260028101549282019290925260039091015460ff161515606082015290565b6102c860405180608001604052806000815260200160008152602001600081526020016000151581525090565b5060009081527f3d8a11862a15163ca73fa8d9e16d69918cd78af58fc339633e5f208633ff7671602090815260408083209383529281528282205482527f3d8a11862a15163ca73fa8d9e16d69918cd78af58fc339633e5f208633ff767281529082902082516080810184528154815260018201549281019290925260028101549282019290925260039091015460ff161515606082015290565b60008281527f3d8a11862a15163ca73fa8d9e16d69918cd78af58fc339633e5f208633ff7671602090815260408083208484529091528120547f3d8a11862a15163ca73fa8d9e16d69918cd78af58fc339633e5f208633ff7670906103c7906103fa565b949350505050565b60006101707f3c7bf052874fa81625121783266a03507bd2cd48b16e571c01a04e8dd3fb07a6610476565b6000806104277f3c7bf052874fa81625121783266a03507bd2cd48b16e571c01a04e8dd3fb07a684610480565b905073ffffffffffffffffffffffffffffffffffffffff81166101ab576040517f7e1a7d8b00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60006101ab825490565b60006101e8838360008181526001830160205260408120548082036104d1576040517ff551fb1400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b8360000160018203815481106104e9576104e961053f565b90600052602060002090600202016001015491505092915050565b60006020828403121561051657600080fd5b5035919050565b6000806040838503121561053057600080fd5b50508035926020909101359150565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fdfea264697066735822122052258fd53a719971d2970e5a567d582d75c31b9ea0350d8dd67f24002a5775e264736f6c63430008110033";

type L2PaidTicketViewConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: L2PaidTicketViewConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class L2PaidTicketView__factory extends ContractFactory {
  constructor(...args: L2PaidTicketViewConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<L2PaidTicketView> {
    return super.deploy(overrides || {}) as Promise<L2PaidTicketView>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): L2PaidTicketView {
    return super.attach(address) as L2PaidTicketView;
  }
  override connect(signer: Signer): L2PaidTicketView__factory {
    return super.connect(signer) as L2PaidTicketView__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): L2PaidTicketViewInterface {
    return new utils.Interface(_abi) as L2PaidTicketViewInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): L2PaidTicketView {
    return new Contract(address, _abi, signerOrProvider) as L2PaidTicketView;
  }
}
