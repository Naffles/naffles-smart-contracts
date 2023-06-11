/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  L1NaffleBase,
  L1NaffleBaseInterface,
} from "../../../../contracts/naffle/ethereum/L1NaffleBase";

const _abi = [
  {
    inputs: [],
    name: "FailedMessageInclusion",
    type: "error",
  },
  {
    inputs: [],
    name: "InvalidAction",
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
    inputs: [],
    name: "NotSupported",
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
    inputs: [
      {
        internalType: "uint256",
        name: "_l2BlockNumber",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_index",
        type: "uint256",
      },
      {
        internalType: "uint16",
        name: "_l2TxNumberInBlock",
        type: "uint16",
      },
      {
        internalType: "bytes",
        name: "_message",
        type: "bytes",
      },
      {
        internalType: "bytes32[]",
        name: "_proof",
        type: "bytes32[]",
      },
    ],
    name: "consumeSetWinnerMessage",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_ethTokenAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_nftId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_paidTicketSpots",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_ticketPriceInWei",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_endTime",
        type: "uint256",
      },
      {
        internalType: "enum NaffleTypes.NaffleType",
        name: "_naffleType",
        type: "uint8",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "l2GasLimit",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "l2GasPerPubdataByteLimit",
            type: "uint256",
          },
        ],
        internalType: "struct NaffleTypes.L2MessageParams",
        name: "_l2MessageParams",
        type: "tuple",
      },
    ],
    name: "createNaffle",
    outputs: [
      {
        internalType: "uint256",
        name: "naffleId",
        type: "uint256",
      },
      {
        internalType: "bytes32",
        name: "txHash",
        type: "bytes32",
      },
    ],
    stateMutability: "payable",
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
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256[]",
        name: "",
        type: "uint256[]",
      },
      {
        internalType: "uint256[]",
        name: "",
        type: "uint256[]",
      },
      {
        internalType: "bytes",
        name: "",
        type: "bytes",
      },
    ],
    name: "onERC1155BatchReceived",
    outputs: [
      {
        internalType: "bytes4",
        name: "",
        type: "bytes4",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "",
        type: "bytes",
      },
    ],
    name: "onERC1155Received",
    outputs: [
      {
        internalType: "bytes4",
        name: "",
        type: "bytes4",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "",
        type: "bytes",
      },
    ],
    name: "onERC721Received",
    outputs: [
      {
        internalType: "bytes4",
        name: "",
        type: "bytes4",
      },
    ],
    stateMutability: "pure",
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
        internalType: "bytes4",
        name: "interfaceId",
        type: "bytes4",
      },
    ],
    name: "supportsInterface",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405234801561001057600080fd5b506120c2806100206000396000f3fe6080604052600436106100bc5760003560e01c80638bb9c5bf11610074578063d547741f1161004e578063d547741f1461023c578063f23a6e611461025c578063f6eea177146102a257600080fd5b80638bb9c5bf146101dc57806391d14854146101fc578063bc197c811461021c57600080fd5b8063248a9ca3116100a5578063248a9ca31461016c5780632f2ff15d1461019a5780638091e048146101bc57600080fd5b806301ffc9a7146100c1578063150b7a02146100f6575b600080fd5b3480156100cd57600080fd5b506100e16100dc366004611741565b6102ca565b60405190151581526020015b60405180910390f35b34801561010257600080fd5b5061013b6101113660046117e1565b7f150b7a023d4804d13e8c85fb27262cb750cf6ba9f9dd3bb30d90f482ceeb4b1f95945050505050565b6040517fffffffff0000000000000000000000000000000000000000000000000000000090911681526020016100ed565b34801561017857600080fd5b5061018c610187366004611854565b610363565b6040519081526020016100ed565b3480156101a657600080fd5b506101ba6101b536600461186d565b610399565b005b3480156101c857600080fd5b506101ba6101d73660046118e2565b6103e2565b3480156101e857600080fd5b506101ba6101f7366004611854565b61050e565b34801561020857600080fd5b506100e161021736600461186d565b61051a565b34801561022857600080fd5b5061013b61023736600461197f565b61052d565b34801561024857600080fd5b506101ba61025736600461186d565b610561565b34801561026857600080fd5b5061013b610277366004611a3e565b7ff23a6e612e1ff4830e658fe43f4e3cb4a5f8170bd5d9e69fb5d7a7fa9e4fdf979695505050505050565b6102b56102b0366004611aba565b6105a5565b604080519283526020830191909152016100ed565b60007fffffffff0000000000000000000000000000000000000000000000000000000082167f150b7a0200000000000000000000000000000000000000000000000000000000148061035d57507fffffffff0000000000000000000000000000000000000000000000000000000082167f4e2312e000000000000000000000000000000000000000000000000000000000145b92915050565b60008181527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604081206002015461035d565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c62281160205260409020600201546103d3816105c7565b6103dd83836105d1565b505050565b61042887878787878080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152508992508891506106459050565b6000808061043886880188611b7d565b92509250925060405160200161047f9060208082526009908201527f73657457696e6e65720000000000000000000000000000000000000000000000604082015260600190565b60405160208183030381529060405280519060200120836040516020016104a69190611c98565b60405160208183030381529060405280519060200120036104d0576104cb828261081a565b610502565b6040517f4a7f394f00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b50505050505050505050565b61051781610a69565b50565b60006105268383610a73565b9392505050565b60006040517fa038794000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604090206002015461059b816105c7565b6103dd8383610aaa565b6000806105b789898989898989610b1e565b9150915097509795505050505050565b6105178133611362565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c6228116020526040902061060890826113e2565b5060405133906001600160a01b0383169084907f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d90600090a45050565b60008681527f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67c4602090815260408083208884529091529020547f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67ba9060ff16156106da576040517f7b04260900000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b80546040805160608101825261ffff8816815260018401546001600160a01b03908116602083015281830188905291517fe4948f43000000000000000000000000000000000000000000000000000000008152919092169190600090839063e4948f4390610754908d908d9087908c908c90600401611cab565b602060405180830381865afa158015610771573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906107959190611d48565b9050806107ce576040517fa0df83c200000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5050506000968752600a0160209081526040808820968852959052505050912080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0016600117905550565b60008281527f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67c2602052604081206004810180547fffffffffffffffffffffffff0000000000000000000000000000000000000000166001600160a01b03851617908190557f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67ba92907501000000000000000000000000000000000000000000900460ff1660018111156108ce576108ce611d6a565b0361096157805460018201546040517f23b872dd0000000000000000000000000000000000000000000000000000000081523060048201526001600160a01b03868116602483015260448201929092529116906323b872dd90606401600060405180830381600087803b15801561094457600080fd5b505af1158015610958573d6000803e3d6000fd5b50505050610a2d565b600160048201547501000000000000000000000000000000000000000000900460ff16600181111561099557610995611d6a565b03610a2d578054600180830154604080516020810182526000815290517ff242432a0000000000000000000000000000000000000000000000000000000081526001600160a01b039094169363f242432a936109fa9330938a93919291600401611d80565b600060405180830381600087803b158015610a1457600080fd5b505af1158015610a28573d6000803e3d6000fd5b505050505b6040516001600160a01b0384169085907f9ccdd6fbecccb3ba5d8faf4887a259f0e6cb4421747e6f3d3858c2a5c22a15aa90600090a350505050565b6105178133610aaa565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c6228116020526040812061052690836113f7565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c62281160205260409020610ae19082611419565b5060405133906001600160a01b0383169084907ff6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b90600090a45050565b600080807f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67ba60028101546040517f70a082310000000000000000000000000000000000000000000000000000000081523360048201529192506001600160a01b0316906370a0823190602401602060405180830381865afa158015610ba7573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610bcb9190611dc3565b158015610c5c575060038101546040517f70a082310000000000000000000000000000000000000000000000000000000081523360048201526001600160a01b03909116906370a0823190602401602060405180830381865afa158015610c36573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610c5a9190611dc3565b155b15610c93576040517f3d693ada00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6005810154610ca29042611df2565b861015610ce3576040517f82e42d11000000000000000000000000000000000000000000000000000000008152600481018790526024015b60405180910390fd5b8060040160008154610cf490611e05565b90915550600481015492506001856001811115610d1357610d13611d6a565b148015610d1f57508715155b80610d4957506000856001811115610d3957610d39611d6a565b148015610d495750806006015488105b15610d83576040517fda865cbe00000000000000000000000000000000000000000000000000000000815260048101899052602401610cda565b6040517f01ffc9a70000000000000000000000000000000000000000000000000000000081527f80ac58cd0000000000000000000000000000000000000000000000000000000060048201526000906001600160a01b038c16906301ffc9a790602401602060405180830381865afa158015610e03573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610e279190611d48565b15610eb557506040517f23b872dd000000000000000000000000000000000000000000000000000000008152336004820152306024820152604481018a90526000906001600160a01b038c16906323b872dd906064015b600060405180830381600087803b158015610e9857600080fd5b505af1158015610eac573d6000803e3d6000fd5b50505050610fd5565b6040517f01ffc9a70000000000000000000000000000000000000000000000000000000081527fd9b67a260000000000000000000000000000000000000000000000000000000060048201526001600160a01b038c16906301ffc9a790602401602060405180830381865afa158015610f32573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610f569190611d48565b15610fa357600190508a6001600160a01b031663f242432a33308d6001604051806020016040528060008152506040518663ffffffff1660e01b8152600401610e7e959493929190611d80565b6040517fa1e9dd9d00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6040805160e0810182526001600160a01b038d168152602081018c905290810185905233606082015260006080820181905260a082015260c0810182600181111561102257611022611d6a565b90526000858152600884016020908152604091829020835181546001600160a01b039182167fffffffffffffffffffffffff00000000000000000000000000000000000000009182161783559285015160018084019190915593850151600283015560608501516003830180549183169190941617909255608084015160048201805460a0870151151574010000000000000000000000000000000000000000027fffffffffffffffffffffff00000000000000000000000000000000000000000090911692909416919091179290921780835560c085015191939192917fffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff90911690750100000000000000000000000000000000000000000090849081111561114e5761114e611d6a565b021790555050825460408051610120810182526001600160a01b038f81168252336020830152918101889052606081018e9052608081018d905260a081018c905260c081018b90529116915060009060e081018960018111156111b3576111b3611d6a565b81526020018460018111156111ca576111ca611d6a565b905260018501546040519192506001600160a01b038085169263eb67241992349216906000906111fe908790602401611e4a565b60408051601f19818403018152919052602080820180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff167fbeec04fb000000000000000000000000000000000000000000000000000000001790528d35908e0135600060405190808252806020026020018201604052801561129257816020015b606081526020019060019003908161127d5790505b50336040518963ffffffff1660e01b81526004016112b69796959493929190611ece565b60206040518083038185885af11580156112d4573d6000803e3d6000fd5b50505050506040513d601f19601f820116820180604052508101906112f99190611dc3565b94508c6001600160a01b0316336001600160a01b03167ffac33cbe84e030c7a2ce84c12728f5a78c4dc1b248d028b8d5c6806de89fad9d888f8f8f8f8f8b60405161134a9796959493929190611f7b565b60405180910390a35050505097509795505050505050565b61136c8282610a73565b6113de57611382816001600160a01b031661142e565b61138d836020611440565b60405160200161139e929190611fc8565b60408051601f19818403018152908290527f08c379a0000000000000000000000000000000000000000000000000000000008252610cda91600401611c98565b5050565b6000610526836001600160a01b038416611639565b6001600160a01b03811660009081526001830160205260408120541515610526565b6000610526836001600160a01b03841661167c565b606061035d6001600160a01b03831660145b6060600061144f836002612049565b61145a906002611df2565b67ffffffffffffffff81111561147257611472611b57565b6040519080825280601f01601f19166020018201604052801561149c576020820181803683370190505b5090507f3000000000000000000000000000000000000000000000000000000000000000816000815181106114d3576114d3612060565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a9053507f78000000000000000000000000000000000000000000000000000000000000008160018151811061153657611536612060565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a905350600160028402015b6001811115611600577f303132333435363738396162636465660000000000000000000000000000000085600f16601081106115ab576115ab612060565b1a60f81b8282815181106115c1576115c1612060565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535060049490941c936000190161156d565b508315610526576040517fc913478500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600081815260018301602052604081205461035d575081546001808201845560008481526020808220909301849055845493815293810190915260409092205590565b6000818152600183016020526040812054801561173a578354600090859060001981019081106116ae576116ae612060565b90600052602060002001549050808560000160018403815481106116d4576116d4612060565b600091825260208083209091019290925591825260018601905260409020819055835484908061170657611706612076565b6001900381819060005260206000200160009055905583600101600084815260200190815260200160002060009055600191505b5092915050565b60006020828403121561175357600080fd5b81357fffffffff000000000000000000000000000000000000000000000000000000008116811461052657600080fd5b6001600160a01b038116811461051757600080fd5b60008083601f8401126117aa57600080fd5b50813567ffffffffffffffff8111156117c257600080fd5b6020830191508360208285010111156117da57600080fd5b9250929050565b6000806000806000608086880312156117f957600080fd5b853561180481611783565b9450602086013561181481611783565b935060408601359250606086013567ffffffffffffffff81111561183757600080fd5b61184388828901611798565b969995985093965092949392505050565b60006020828403121561186657600080fd5b5035919050565b6000806040838503121561188057600080fd5b82359150602083013561189281611783565b809150509250929050565b60008083601f8401126118af57600080fd5b50813567ffffffffffffffff8111156118c757600080fd5b6020830191508360208260051b85010111156117da57600080fd5b600080600080600080600060a0888a0312156118fd57600080fd5b8735965060208801359550604088013561ffff8116811461191d57600080fd5b9450606088013567ffffffffffffffff8082111561193a57600080fd5b6119468b838c01611798565b909650945060808a013591508082111561195f57600080fd5b5061196c8a828b0161189d565b989b979a50959850939692959293505050565b60008060008060008060008060a0898b03121561199b57600080fd5b88356119a681611783565b975060208901356119b681611783565b9650604089013567ffffffffffffffff808211156119d357600080fd5b6119df8c838d0161189d565b909850965060608b01359150808211156119f857600080fd5b611a048c838d0161189d565b909650945060808b0135915080821115611a1d57600080fd5b50611a2a8b828c01611798565b999c989b5096995094979396929594505050565b60008060008060008060a08789031215611a5757600080fd5b8635611a6281611783565b95506020870135611a7281611783565b94506040870135935060608701359250608087013567ffffffffffffffff811115611a9c57600080fd5b611aa889828a01611798565b979a9699509497509295939492505050565b6000806000806000806000878903610100811215611ad757600080fd5b8835611ae281611783565b97506020890135965060408901359550606089013594506080890135935060a089013560028110611b1257600080fd5b925060407fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff4082011215611b4457600080fd5b5060c08801905092959891949750929550565b634e487b7160e01b600052604160045260246000fd5b8035611b7881611783565b919050565b600080600060608486031215611b9257600080fd5b833567ffffffffffffffff80821115611baa57600080fd5b818601915086601f830112611bbe57600080fd5b813581811115611bd057611bd0611b57565b604051601f8201601f19908116603f01168101908382118183101715611bf857611bf8611b57565b81604052828152896020848701011115611c1157600080fd5b82602086016020830137600060208483010152809750505050505060208401359150611c3f60408501611b6d565b90509250925092565b60005b83811015611c63578181015183820152602001611c4b565b50506000910152565b60008151808452611c84816020860160208601611c48565b601f01601f19169290920160200192915050565b6020815260006105266020830184611c6c565b8581528460208201526080604082015261ffff84511660808201526001600160a01b0360208501511660a082015260006040850151606060c0840152611cf460e0840182611c6c565b905082810360608401528381527f07ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff841115611d2e57600080fd5b8360051b8086602084013701602001979650505050505050565b600060208284031215611d5a57600080fd5b8151801515811461052657600080fd5b634e487b7160e01b600052602160045260246000fd5b60006001600160a01b03808816835280871660208401525084604083015283606083015260a06080830152611db860a0830184611c6c565b979650505050505050565b600060208284031215611dd557600080fd5b5051919050565b634e487b7160e01b600052601160045260246000fd5b8082018082111561035d5761035d611ddc565b60006000198203611e1857611e18611ddc565b5060010190565b6002811061051757634e487b7160e01b600052602160045260246000fd5b611e4681611e1f565b9052565b6000610120820190506001600160a01b038084511683528060208501511660208401525060408301516040830152606083015160608301526080830151608083015260a083015160a083015260c083015160c083015260e0830151611eb260e0840182611e3d565b5061010080840151611ec682850182611e3d565b505092915050565b6001600160a01b038816815260006020888184015260e06040840152611ef760e0840189611c6c565b87606085015286608085015283810360a08501528086518083528383019150838160051b84010184890160005b83811015611f5257601f19868403018552611f40838351611c6c565b94870194925090860190600101611f24565b50506001600160a01b03881660c08801529450611f6f9350505050565b98975050505050505050565b600060e082019050888252876020830152866040830152856060830152846080830152611fa784611e1f565b8360a0830152611fb683611e1f565b8260c083015298975050505050505050565b7f416363657373436f6e74726f6c3a206163636f756e7420000000000000000000815260008351612000816017850160208801611c48565b7f206973206d697373696e6720726f6c6520000000000000000000000000000000601791840191820152835161203d816028840160208801611c48565b01602801949350505050565b808202811582820484141761035d5761035d611ddc565b634e487b7160e01b600052603260045260246000fd5b634e487b7160e01b600052603160045260246000fdfea264697066735822122086490b2d9eb26d7f8d08960355022b1456fd5a07b3b2731c07768ae407ef3aa464736f6c63430008110033";

type L1NaffleBaseConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: L1NaffleBaseConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class L1NaffleBase__factory extends ContractFactory {
  constructor(...args: L1NaffleBaseConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<L1NaffleBase> {
    return super.deploy(overrides || {}) as Promise<L1NaffleBase>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): L1NaffleBase {
    return super.attach(address) as L1NaffleBase;
  }
  override connect(signer: Signer): L1NaffleBase__factory {
    return super.connect(signer) as L1NaffleBase__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): L1NaffleBaseInterface {
    return new utils.Interface(_abi) as L1NaffleBaseInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): L1NaffleBase {
    return new Contract(address, _abi, signerOrProvider) as L1NaffleBase;
  }
}
