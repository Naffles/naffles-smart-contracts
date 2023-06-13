/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../../../common";
import type {
  L2PaidTicketAdmin,
  L2PaidTicketAdminInterface,
} from "../../../../../../contracts/tokens/zksync/ticket/paid/L2PaidTicketAdmin";

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
    name: "Ownable__NotOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "Ownable__NotTransitiveOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "RefundFailed",
    type: "error",
  },
  {
    inputs: [],
    name: "SafeOwnable__NotNomineeOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "UintUtils__InsufficientHexLength",
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
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
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
        internalType: "uint256",
        name: "ticketId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "ticketIdOnNaffle",
        type: "uint256",
      },
    ],
    name: "PaidTicketRefundedAndBurned",
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
    name: "acceptOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
    ],
    name: "getRoleAdmin",
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
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "grantRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "hasRole",
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
    inputs: [],
    name: "nomineeOwner",
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
    name: "owner",
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
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
    ],
    name: "renounceRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "revokeRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_admin",
        type: "address",
      },
    ],
    name: "setAdmin",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_l2NaffleContractAddress",
        type: "address",
      },
    ],
    name: "setL2NaffleContractAddress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405234801561001057600080fd5b50610cb1806100206000396000f3fe608060405234801561001057600080fd5b50600436106100c95760003560e01c80638bb9c5bf11610081578063d50069091161005b578063d500690914610182578063d547741f14610195578063f2fde38b146101a857600080fd5b80638bb9c5bf146101445780638da5cb5b1461015757806391d148541461015f57600080fd5b8063704b6c02116100b2578063704b6c021461010957806379ba50971461011c5780638ab5150a1461012457600080fd5b8063248a9ca3146100ce5780632f2ff15d146100f4575b600080fd5b6100e16100dc366004610aa5565b6101bb565b6040519081526020015b60405180910390f35b610107610102366004610ada565b6101f3565b005b610107610117366004610b06565b61023c565b61010761029c565b61012c6102f8565b6040516001600160a01b0390911681526020016100eb565b610107610152366004610aa5565b610307565b61012c610310565b61017261016d366004610ada565b61031a565b60405190151581526020016100eb565b610107610190366004610b06565b61032d565b6101076101a3366004610ada565b610345565b6101076101b6366004610b06565b610389565b60008181527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c62281160205260408120600201545b92915050565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604090206002015461022d816103e4565b61023783836103ee565b505050565b610244610462565b6001600160a01b0316336001600160a01b03161461028e576040517f2f7a8ee100000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6102996000826103ee565b50565b6102a4610495565b6001600160a01b0316336001600160a01b0316146102ee576040517fefd1052d00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6102f66104bd565b565b6000610302610495565b905090565b61029981610504565b6000610302610462565b6000610326838361050e565b9392505050565b6000610338816103e4565b61034182610545565b5050565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604090206002015461037f816103e4565b6102378383610596565b610391610462565b6001600160a01b0316336001600160a01b0316146103db576040517f2f7a8ee100000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6102998161060a565b6102998133610613565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604090206104259082610698565b5060405133906001600160a01b0383169084907f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d90600090a45050565b60007f8a22373512790c48b83a1fe2efdd2888d4a917bcdc24d0adf63e60f6716804605b546001600160a01b0316919050565b60007f24aa1f7b31fd188a8d3ecfb06bc55c806040e59b03bd4396283442fce6617890610486565b6104c6336106ad565b7f24aa1f7b31fd188a8d3ecfb06bc55c806040e59b03bd4396283442fce6617890805473ffffffffffffffffffffffffffffffffffffffff19169055565b6102998133610596565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604081206103269083610734565b807f3d8a11862a15163ca73fa8d9e16d69918cd78af58fc339633e5f208633ff76705b805473ffffffffffffffffffffffffffffffffffffffff19166001600160a01b039290921691909117905550565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604090206105cd9082610756565b5060405133906001600160a01b0383169084907ff6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b90600090a45050565b6102998161076b565b61061d828261050e565b61034157610633816001600160a01b0316610792565b61063e8360206107a4565b60405160200161064f929190610b45565b60408051601f19818403018152908290527f08c379a000000000000000000000000000000000000000000000000000000000825261068f91600401610bc6565b60405180910390fd5b6000610326836001600160a01b03841661099d565b7f8a22373512790c48b83a1fe2efdd2888d4a917bcdc24d0adf63e60f67168046080546040516001600160a01b038481169216907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a3805473ffffffffffffffffffffffffffffffffffffffff19166001600160a01b0392909216919091179055565b6001600160a01b03811660009081526001830160205260408120541515610326565b6000610326836001600160a01b0384166109e0565b807f24aa1f7b31fd188a8d3ecfb06bc55c806040e59b03bd4396283442fce6617890610568565b60606101ed6001600160a01b03831660145b606060006107b3836002610c0f565b6107be906002610c26565b67ffffffffffffffff8111156107d6576107d6610c39565b6040519080825280601f01601f191660200182016040528015610800576020820181803683370190505b5090507f30000000000000000000000000000000000000000000000000000000000000008160008151811061083757610837610c4f565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a9053507f78000000000000000000000000000000000000000000000000000000000000008160018151811061089a5761089a610c4f565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a905350600160028402015b6001811115610964577f303132333435363738396162636465660000000000000000000000000000000085600f166010811061090f5761090f610c4f565b1a60f81b82828151811061092557610925610c4f565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535060049490941c93600019016108d1565b508315610326576040517fc913478500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60008181526001830160205260408120546101ed575081546001808201845560008481526020808220909301849055845493815293810190915260409092205590565b60008181526001830160205260408120548015610a9e57835460009085906000198101908110610a1257610a12610c4f565b9060005260206000200154905080856000016001840381548110610a3857610a38610c4f565b6000918252602080832090910192909255918252600186019052604090208190558354849080610a6a57610a6a610c65565b6001900381819060005260206000200160009055905583600101600084815260200190815260200160002060009055600191505b5092915050565b600060208284031215610ab757600080fd5b5035919050565b80356001600160a01b0381168114610ad557600080fd5b919050565b60008060408385031215610aed57600080fd5b82359150610afd60208401610abe565b90509250929050565b600060208284031215610b1857600080fd5b61032682610abe565b60005b83811015610b3c578181015183820152602001610b24565b50506000910152565b7f416363657373436f6e74726f6c3a206163636f756e7420000000000000000000815260008351610b7d816017850160208801610b21565b7f206973206d697373696e6720726f6c65200000000000000000000000000000006017918401918201528351610bba816028840160208801610b21565b01602801949350505050565b6020815260008251806020840152610be5816040850160208701610b21565b601f01601f19169190910160400192915050565b634e487b7160e01b600052601160045260246000fd5b80820281158282048414176101ed576101ed610bf9565b808201808211156101ed576101ed610bf9565b634e487b7160e01b600052604160045260246000fd5b634e487b7160e01b600052603260045260246000fd5b634e487b7160e01b600052603160045260246000fdfea26469706673582212206b38ec21ec9c367ae2eb348684d5ed3c26b428c97b66c7da03158757ffa7892464736f6c63430008110033";

type L2PaidTicketAdminConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: L2PaidTicketAdminConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class L2PaidTicketAdmin__factory extends ContractFactory {
  constructor(...args: L2PaidTicketAdminConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<L2PaidTicketAdmin> {
    return super.deploy(overrides || {}) as Promise<L2PaidTicketAdmin>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): L2PaidTicketAdmin {
    return super.attach(address) as L2PaidTicketAdmin;
  }
  override connect(signer: Signer): L2PaidTicketAdmin__factory {
    return super.connect(signer) as L2PaidTicketAdmin__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): L2PaidTicketAdminInterface {
    return new utils.Interface(_abi) as L2PaidTicketAdminInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): L2PaidTicketAdmin {
    return new Contract(address, _abi, signerOrProvider) as L2PaidTicketAdmin;
  }
}
