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
        name: "_naffleId",
        type: "uint256",
      },
    ],
    name: "_getNaffleById",
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
        name: "naffle",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_zkSyncAddress",
        type: "address",
      },
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
  "0x608060405234801561001057600080fd5b5061218f806100206000396000f3fe608060405234801561001057600080fd5b50600436106100d45760003560e01c80638bb9c5bf11610081578063d547741f1161005b578063d547741f14610221578063e2ed3f1214610234578063f23a6e611461024757600080fd5b80638bb9c5bf146101e857806391d14854146101fb578063bc197c811461020e57600080fd5b8063248a9ca3116100b2578063248a9ca31461018a5780632f2ff15d146101ab578063756f42d2146101c057600080fd5b806301ffc9a7146100d9578063150b7a0214610101578063184ff1e41461016a575b600080fd5b6100ec6100e73660046117e1565b610280565b60405190151581526020015b60405180910390f35b61013961010f366004611881565b7f150b7a023d4804d13e8c85fb27262cb750cf6ba9f9dd3bb30d90f482ceeb4b1f95945050505050565b6040517fffffffff0000000000000000000000000000000000000000000000000000000090911681526020016100f8565b61017d6101783660046118f4565b610319565b6040516100f8919061194e565b61019d6101983660046118f4565b610430565b6040519081526020016100f8565b6101be6101b93660046119b8565b610466565b005b6101d36101ce3660046119e8565b6104af565b604080519283526020830191909152016100f8565b6101be6101f63660046118f4565b6104cf565b6100ec6102093660046119b8565b6104db565b61013961021c366004611a8f565b6104ee565b6101be61022f3660046119b8565b610522565b6101be610242366004611b4e565b610566565b610139610255366004611be9565b7ff23a6e612e1ff4830e658fe43f4e3cb4a5f8170bd5d9e69fb5d7a7fa9e4fdf979695505050505050565b60007fffffffff0000000000000000000000000000000000000000000000000000000082167f150b7a0200000000000000000000000000000000000000000000000000000000148061031357507fffffffff0000000000000000000000000000000000000000000000000000000082167f4e2312e000000000000000000000000000000000000000000000000000000000145b92915050565b6103566040805160e081018252600080825260208201819052918101829052606081018290526080810182905260a081018290529060c082015290565b60008281527f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67c26020908152604091829020825160e08101845281546001600160a01b039081168252600180840154948301949094526002830154948201949094526003820154841660608201526004820154938416608082015260ff7401000000000000000000000000000000000000000085048116151560a08301529093919260c0850192600160a81b9004909116908111156104165761041661190d565b60018111156104275761042761190d565b90525092915050565b60008181527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c6228116020526040812060020154610313565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c62281160205260409020600201546104a081610694565b6104aa838361069e565b505050565b6000806104c0888888888888610712565b91509150965096945050505050565b6104d881610f4c565b50565b60006104e78383610f56565b9392505050565b60006040517fa038794000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604090206002015461055c81610694565b6104aa8383610f8d565b6105ad8888888888888080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152508a92508991506110019050565b600080806105bd86880188611c8b565b9250925092506040516020016106049060208082526009908201527f73657457696e6e65720000000000000000000000000000000000000000000000604082015260600190565b604051602081830303815290604052805190602001208360405160200161062b9190611da6565b60405160208183030381529060405280519060200120036106555761065082826111d7565b610687565b6040517f4a7f394f00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5050505050505050505050565b6104d88133611402565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604090206106d59082611482565b5060405133906001600160a01b0383169084907f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d90600090a45050565b600080807f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67ba60028101546040517f70a082310000000000000000000000000000000000000000000000000000000081523360048201529192506001600160a01b0316906370a0823190602401602060405180830381865afa15801561079b573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906107bf9190611db9565b158015610850575060038101546040517f70a082310000000000000000000000000000000000000000000000000000000081523360048201526001600160a01b03909116906370a0823190602401602060405180830381865afa15801561082a573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061084e9190611db9565b155b15610887576040517f3d693ada00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60058101546108969042611de8565b8510156108d7576040517f82e42d11000000000000000000000000000000000000000000000000000000008152600481018690526024015b60405180910390fd5b80600401600081546108e890611dfb565b909155506004810154925060018460018111156109075761090761190d565b14801561091357508615155b8061093d5750600084600181111561092d5761092d61190d565b14801561093d5750806006015487105b15610977576040517fda865cbe000000000000000000000000000000000000000000000000000000008152600481018890526024016108ce565b6040517f01ffc9a70000000000000000000000000000000000000000000000000000000081527f80ac58cd0000000000000000000000000000000000000000000000000000000060048201526000906001600160a01b038b16906301ffc9a790602401602060405180830381865afa1580156109f7573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610a1b9190611e15565b15610aa957506040517f23b872dd000000000000000000000000000000000000000000000000000000008152336004820152306024820152604481018990526000906001600160a01b038b16906323b872dd906064015b600060405180830381600087803b158015610a8c57600080fd5b505af1158015610aa0573d6000803e3d6000fd5b50505050610bdd565b6040517f01ffc9a70000000000000000000000000000000000000000000000000000000081527fd9b67a260000000000000000000000000000000000000000000000000000000060048201526001600160a01b038b16906301ffc9a790602401602060405180830381865afa158015610b26573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610b4a9190611e15565b15610bab5750604080516020810182526000815290517ff242432a0000000000000000000000000000000000000000000000000000000081526001916001600160a01b038c169163f242432a91610a7291339130918f918891600401611e37565b6040517fa1e9dd9d00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6040805160e0810182526001600160a01b038c168152602081018b905290810185905233606082015260006080820181905260a082015260c08101826001811115610c2a57610c2a61190d565b90526000858152600884016020908152604091829020835181546001600160a01b039182167fffffffffffffffffffffffff00000000000000000000000000000000000000009182161783559285015160018084019190915593850151600283015560608501516003830180549183169190941617909255608084015160048201805460a0870151151574010000000000000000000000000000000000000000027fffffffffffffffffffffff00000000000000000000000000000000000000000090911692909416919091179290921780835560c085015191939192917fffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff90911690600160a81b908490811115610d4457610d4461190d565b021790555050825460408051610120810182526001600160a01b038e81168252336020830152918101889052606081018d9052608081018c905260a081018b905260c081018a90529116915060009060e08101886001811115610da957610da961190d565b8152602001846001811115610dc057610dc061190d565b905260018501546040519192506001600160a01b038085169263eb6724199234921690600090610df4908790602401611e7a565b60408051601f19818403018152918152602080830180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff167fbeec04fb00000000000000000000000000000000000000000000000000000000179052815160008082529181019092526127109161032091610e7c565b6060815260200190600190039081610e675790505b5060006040518963ffffffff1660e01b8152600401610ea19796959493929190611efe565b60206040518083038185885af1158015610ebf573d6000803e3d6000fd5b50505050506040513d601f19601f82011682018060405250810190610ee49190611db9565b94508b6001600160a01b0316336001600160a01b03167ffac33cbe84e030c7a2ce84c12728f5a78c4dc1b248d028b8d5c6806de89fad9d888e8e8e8e8e8b604051610f359796959493929190611fab565b60405180910390a350505050965096945050505050565b6104d88133610f8d565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c622811602052604081206104e79083611497565b60008281527fd3889cc5458b268d0544e5534672df1296288ca3f93cbd39bd6f497a5c62281160205260409020610fc490826114b9565b5060405133906001600160a01b0383169084907ff6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b90600090a45050565b60008681527f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67c4602090815260408083208884529091529020547f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67ba9060ff1615611096576040517f7b04260900000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b80546040805160608101825261ffff8816815260018401546001600160a01b03908116602083015281830188905291517fe4948f43000000000000000000000000000000000000000000000000000000008152919092169190600090839063e4948f4390611110908d908d9087908c908c90600401611ff8565b602060405180830381865afa15801561112d573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906111519190611e15565b90508061118a576040517fa0df83c200000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5050506000968752600a0160209081526040808820968852959052505050912080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001660011790555050565b60008281527f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67c2602052604081206004810180547fffffffffffffffffffffffff0000000000000000000000000000000000000000166001600160a01b03851617908190557f470a3a09bc7c093da4939d34501d4f187895d1929b6aa0b7092dcd8f223c67ba9290600160a81b900460ff1660018111156112795761127961190d565b0361130c57805460018201546040517f23b872dd0000000000000000000000000000000000000000000000000000000081523060048201526001600160a01b03868116602483015260448201929092529116906323b872dd90606401600060405180830381600087803b1580156112ef57600080fd5b505af1158015611303573d6000803e3d6000fd5b505050506113c6565b60016004820154600160a81b900460ff16600181111561132e5761132e61190d565b036113c6578054600180830154604080516020810182526000815290517ff242432a0000000000000000000000000000000000000000000000000000000081526001600160a01b039094169363f242432a936113939330938a93919291600401611e37565b600060405180830381600087803b1580156113ad57600080fd5b505af11580156113c1573d6000803e3d6000fd5b505050505b6040516001600160a01b0384169085907f9ccdd6fbecccb3ba5d8faf4887a259f0e6cb4421747e6f3d3858c2a5c22a15aa90600090a350505050565b61140c8282610f56565b61147e57611422816001600160a01b03166114ce565b61142d8360206114e0565b60405160200161143e929190612095565b60408051601f19818403018152908290527f08c379a00000000000000000000000000000000000000000000000000000000082526108ce91600401611da6565b5050565b60006104e7836001600160a01b0384166116d9565b6001600160a01b038116600090815260018301602052604081205415156104e7565b60006104e7836001600160a01b03841661171c565b60606103136001600160a01b03831660145b606060006114ef836002612116565b6114fa906002611de8565b67ffffffffffffffff81111561151257611512611c65565b6040519080825280601f01601f19166020018201604052801561153c576020820181803683370190505b5090507f3000000000000000000000000000000000000000000000000000000000000000816000815181106115735761157361212d565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a9053507f7800000000000000000000000000000000000000000000000000000000000000816001815181106115d6576115d661212d565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a905350600160028402015b60018111156116a0577f303132333435363738396162636465660000000000000000000000000000000085600f166010811061164b5761164b61212d565b1a60f81b8282815181106116615761166161212d565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535060049490941c936000190161160d565b5083156104e7576040517fc913478500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6000818152600183016020526040812054610313575081546001808201845560008481526020808220909301849055845493815293810190915260409092205590565b600081815260018301602052604081205480156117da5783546000908590600019810190811061174e5761174e61212d565b90600052602060002001549050808560000160018403815481106117745761177461212d565b60009182526020808320909101929092559182526001860190526040902081905583548490806117a6576117a6612143565b6001900381819060005260206000200160009055905583600101600084815260200190815260200160002060009055600191505b5092915050565b6000602082840312156117f357600080fd5b81357fffffffff00000000000000000000000000000000000000000000000000000000811681146104e757600080fd5b6001600160a01b03811681146104d857600080fd5b60008083601f84011261184a57600080fd5b50813567ffffffffffffffff81111561186257600080fd5b60208301915083602082850101111561187a57600080fd5b9250929050565b60008060008060006080868803121561189957600080fd5b85356118a481611823565b945060208601356118b481611823565b935060408601359250606086013567ffffffffffffffff8111156118d757600080fd5b6118e388828901611838565b969995985093965092949392505050565b60006020828403121561190657600080fd5b5035919050565b634e487b7160e01b600052602160045260246000fd5b600281106104d857634e487b7160e01b600052602160045260246000fd5b61194a81611923565b9052565b600060e0820190506001600160a01b0380845116835260208401516020840152604084015160408401528060608501511660608401528060808501511660808401525060a0830151151560a083015260c08301516119ab81611923565b8060c08401525092915050565b600080604083850312156119cb57600080fd5b8235915060208301356119dd81611823565b809150509250929050565b60008060008060008060c08789031215611a0157600080fd5b8635611a0c81611823565b95506020870135945060408701359350606087013592506080870135915060a087013560028110611a3c57600080fd5b809150509295509295509295565b60008083601f840112611a5c57600080fd5b50813567ffffffffffffffff811115611a7457600080fd5b6020830191508360208260051b850101111561187a57600080fd5b60008060008060008060008060a0898b031215611aab57600080fd5b8835611ab681611823565b97506020890135611ac681611823565b9650604089013567ffffffffffffffff80821115611ae357600080fd5b611aef8c838d01611a4a565b909850965060608b0135915080821115611b0857600080fd5b611b148c838d01611a4a565b909650945060808b0135915080821115611b2d57600080fd5b50611b3a8b828c01611838565b999c989b5096995094979396929594505050565b60008060008060008060008060c0898b031215611b6a57600080fd5b8835611b7581611823565b97506020890135965060408901359550606089013561ffff81168114611b9a57600080fd5b9450608089013567ffffffffffffffff80821115611bb757600080fd5b611bc38c838d01611838565b909650945060a08b0135915080821115611bdc57600080fd5b50611b3a8b828c01611a4a565b60008060008060008060a08789031215611c0257600080fd5b8635611c0d81611823565b95506020870135611c1d81611823565b94506040870135935060608701359250608087013567ffffffffffffffff811115611c4757600080fd5b611c5389828a01611838565b979a9699509497509295939492505050565b634e487b7160e01b600052604160045260246000fd5b8035611c8681611823565b919050565b600080600060608486031215611ca057600080fd5b833567ffffffffffffffff80821115611cb857600080fd5b818601915086601f830112611ccc57600080fd5b813581811115611cde57611cde611c65565b604051601f8201601f19908116603f01168101908382118183101715611d0657611d06611c65565b81604052828152896020848701011115611d1f57600080fd5b82602086016020830137600060208483010152809750505050505060208401359150611d4d60408501611c7b565b90509250925092565b60005b83811015611d71578181015183820152602001611d59565b50506000910152565b60008151808452611d92816020860160208601611d56565b601f01601f19169290920160200192915050565b6020815260006104e76020830184611d7a565b600060208284031215611dcb57600080fd5b5051919050565b634e487b7160e01b600052601160045260246000fd5b8082018082111561031357610313611dd2565b60006000198203611e0e57611e0e611dd2565b5060010190565b600060208284031215611e2757600080fd5b815180151581146104e757600080fd5b60006001600160a01b03808816835280871660208401525084604083015283606083015260a06080830152611e6f60a0830184611d7a565b979650505050505050565b6000610120820190506001600160a01b038084511683528060208501511660208401525060408301516040830152606083015160608301526080830151608083015260a083015160a083015260c083015160c083015260e0830151611ee260e0840182611941565b5061010080840151611ef682850182611941565b505092915050565b6001600160a01b038816815260006020888184015260e06040840152611f2760e0840189611d7a565b87606085015286608085015283810360a08501528086518083528383019150838160051b84010184890160005b83811015611f8257601f19868403018552611f70838351611d7a565b94870194925090860190600101611f54565b50506001600160a01b03881660c08801529450611f9f9350505050565b98975050505050505050565b600060e082019050888252876020830152866040830152856060830152846080830152611fd784611923565b8360a0830152611fe683611923565b8260c083015298975050505050505050565b8581528460208201526080604082015261ffff84511660808201526001600160a01b0360208501511660a082015260006040850151606060c084015261204160e0840182611d7a565b905082810360608401528381527f07ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff84111561207b57600080fd5b8360051b8086602084013701602001979650505050505050565b7f416363657373436f6e74726f6c3a206163636f756e74200000000000000000008152600083516120cd816017850160208801611d56565b7f206973206d697373696e6720726f6c6520000000000000000000000000000000601791840191820152835161210a816028840160208801611d56565b01602801949350505050565b808202811582820484141761031357610313611dd2565b634e487b7160e01b600052603260045260246000fd5b634e487b7160e01b600052603160045260246000fdfea2646970667358221220d052a647881a1be100c75437fc4e5a75133b1004dfe8cfe1c8e75c53a663238964736f6c63430008110033";

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
