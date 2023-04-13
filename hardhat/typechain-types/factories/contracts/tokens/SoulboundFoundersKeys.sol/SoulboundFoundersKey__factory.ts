/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  SoulboundFoundersKey,
  SoulboundFoundersKeyInterface,
} from "../../../../contracts/tokens/SoulboundFoundersKeys.sol/SoulboundFoundersKey";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_foundersKeysAddress",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "CantApprove",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "NotOwnerOfToken",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Soulbound",
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
        name: "approved",
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
        indexed: false,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Burned",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "owner",
        type: "address",
      },
    ],
    name: "Minted",
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
    name: "DEFAULT_ADMIN_ROLE",
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
    name: "FoundersKeysAddress",
    outputs: [
      {
        internalType: "contract IERC721A",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "STAKING_CONTRACT_ROLE",
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
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
    ],
    name: "balanceOf",
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
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "getApproved",
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
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "operator",
        type: "address",
      },
    ],
    name: "isApprovedForAll",
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
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
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
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "ownerOf",
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
    name: "renounceOwnership",
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
        name: "_to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "safeMint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
    ],
    name: "setApprovalForAll",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_foundersKeysAddress",
        type: "address",
      },
    ],
    name: "setFoundersKeysAddress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes4",
        name: "_interfaceId",
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
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "symbol",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "tokenURI",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newOwner",
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
  "0x60806040523480156200001157600080fd5b506040516200232438038062002324833981016040819052620000349162000206565b6040518060400160405280601f81526020017f536f756c626f756e64204e6166666c657320466f756e64657273204b657973008152506040518060400160405280600681526020016553424e464c5360d01b81525081600090816200009a9190620002dd565b506001620000a98282620002dd565b505050620000c6620000c0620000fc60201b60201c565b62000100565b600880546001600160a01b0319166001600160a01b038316179055620000f56000620000ef3390565b62000152565b50620003a9565b3390565b600680546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b6200015e828262000162565b5050565b60008281526007602090815260408083206001600160a01b038516845290915290205460ff166200015e5760008281526007602090815260408083206001600160a01b03851684529091529020805460ff19166001179055620001c23390565b6001600160a01b0316816001600160a01b0316837f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d60405160405180910390a45050565b6000602082840312156200021957600080fd5b81516001600160a01b03811681146200023157600080fd5b9392505050565b634e487b7160e01b600052604160045260246000fd5b600181811c908216806200026357607f821691505b6020821081036200028457634e487b7160e01b600052602260045260246000fd5b50919050565b601f821115620002d857600081815260208120601f850160051c81016020861015620002b35750805b601f850160051c820191505b81811015620002d457828155600101620002bf565b5050505b505050565b81516001600160401b03811115620002f957620002f962000238565b62000311816200030a84546200024e565b846200028a565b602080601f831160018114620003495760008415620003305750858301515b600019600386901b1c1916600185901b178555620002d4565b600085815260208120601f198616915b828110156200037a5788860151825594840194600190910190840162000359565b5085821015620003995787850151600019600388901b60f8161c191681555b5050505050600190811b01905550565b611f6b80620003b96000396000f3fe608060405234801561001057600080fd5b50600436106101b95760003560e01c806370a08231116100f9578063a22cb46511610097578063d547741f11610071578063d547741f146103c0578063d8124616146103d3578063e985e9c5146103fa578063f2fde38b1461043657600080fd5b8063a22cb4651461038c578063b88d4fde1461039a578063c87b56dd146103ad57600080fd5b806391d14854116100d357806391d148541461033057806395d89b4114610369578063a144819414610371578063a217fddf1461038457600080fd5b806370a0823114610304578063715018a6146103175780638da5cb5b1461031f57600080fd5b80632f2ff15d1161016657806342966c681161014057806342966c68146102b8578063534bcbc4146102cb5780635e3189f5146102de5780636352211e146102f157600080fd5b80632f2ff15d1461027f57806336568abe1461029257806342842e0e146102a557600080fd5b8063095ea7b311610197578063095ea7b31461022657806323b872dd1461023b578063248a9ca31461024e57600080fd5b806301ffc9a7146101be57806306fdde03146101e6578063081812fc146101fb575b600080fd5b6101d16101cc366004611a39565b610449565b60405190151581526020015b60405180910390f35b6101ee610469565b6040516101dd9190611aa6565b61020e610209366004611ab9565b6104fb565b6040516001600160a01b0390911681526020016101dd565b610239610234366004611ae7565b610522565b005b610239610249366004611b13565b610554565b61027161025c366004611ab9565b60009081526007602052604090206001015490565b6040519081526020016101dd565b61023961028d366004611b54565b6105e5565b6102396102a0366004611b54565b61060a565b6102396102b3366004611b13565b610696565b6102396102c6366004611ab9565b6106b1565b6102396102d9366004611b84565b61071b565b60085461020e906001600160a01b031681565b61020e6102ff366004611ab9565b610756565b610271610312366004611b84565b6107bb565b610239610855565b6006546001600160a01b031661020e565b6101d161033e366004611b54565b60009182526007602090815260408084206001600160a01b0393909316845291905290205460ff1690565b6101ee610869565b61023961037f366004611ae7565b610878565b610271600081565b610239610234366004611ba1565b6102396103a8366004611c43565b6109bd565b6101ee6103bb366004611ab9565b610a4b565b6102396103ce366004611b54565b610ad6565b6102717f1a22aef9db7f016755e82dde60cb4679c85f5f4f349dab1736b426fa9435648581565b6101d1610408366004611cf2565b6001600160a01b03918216600090815260056020908152604080832093909416825291909152205460ff1690565b610239610444366004611b84565b610afb565b600061045482610b8b565b80610463575061046382610c6e565b92915050565b60606000805461047890611d20565b80601f01602080910402602001604051908101604052809291908181526020018280546104a490611d20565b80156104f15780601f106104c6576101008083540402835291602001916104f1565b820191906000526020600020905b8154815290600101906020018083116104d457829003601f168201915b5050505050905090565b600061050682610cc4565b506000908152600460205260409020546001600160a01b031690565b6040517fa25ef65c00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b61055e3382610d28565b6105d55760405162461bcd60e51b815260206004820152602d60248201527f4552433732313a2063616c6c6572206973206e6f7420746f6b656e206f776e6560448201527f72206f7220617070726f7665640000000000000000000000000000000000000060648201526084015b60405180910390fd5b6105e0838383610da7565b505050565b60008281526007602052604090206001015461060081610fea565b6105e08383610ff4565b6001600160a01b03811633146106885760405162461bcd60e51b815260206004820152602f60248201527f416363657373436f6e74726f6c3a2063616e206f6e6c792072656e6f756e636560448201527f20726f6c657320666f722073656c66000000000000000000000000000000000060648201526084016105cc565b6106928282611096565b5050565b6105e0838383604051806020016040528060008152506109bd565b7f1a22aef9db7f016755e82dde60cb4679c85f5f4f349dab1736b426fa943564856106db81610fea565b6106e482611119565b6040518281527fd83c63197e8e676d80ab0122beba9a9d20f3828839e9a1d6fe81d242e9cd7e6e9060200160405180910390a15050565b600061072681610fea565b506008805473ffffffffffffffffffffffffffffffffffffffff19166001600160a01b0392909216919091179055565b6000818152600260205260408120546001600160a01b0316806104635760405162461bcd60e51b815260206004820152601860248201527f4552433732313a20696e76616c696420746f6b656e204944000000000000000060448201526064016105cc565b60006001600160a01b0382166108395760405162461bcd60e51b815260206004820152602960248201527f4552433732313a2061646472657373207a65726f206973206e6f74206120766160448201527f6c6964206f776e6572000000000000000000000000000000000000000000000060648201526084016105cc565b506001600160a01b031660009081526003602052604090205490565b61085d6111c9565b6108676000611223565b565b60606001805461047890611d20565b7f1a22aef9db7f016755e82dde60cb4679c85f5f4f349dab1736b426fa943564856108a281610fea565b6008546040517f6352211e000000000000000000000000000000000000000000000000000000008152600481018490526001600160a01b03858116921690636352211e90602401602060405180830381865afa158015610906573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061092a9190611d5a565b6001600160a01b03161461096d576040517f3b94a199000000000000000000000000000000000000000000000000000000008152600481018390526024016105cc565b6109778383611282565b604080518381526001600160a01b03851660208201527fb9203d657e9c0ec8274c818292ab0f58b04e1970050716891770eb1bab5d655e910160405180910390a1505050565b6109c73383610d28565b610a395760405162461bcd60e51b815260206004820152602d60248201527f4552433732313a2063616c6c6572206973206e6f7420746f6b656e206f776e6560448201527f72206f7220617070726f7665640000000000000000000000000000000000000060648201526084016105cc565b610a458484848461129c565b50505050565b6008546040517fc87b56dd000000000000000000000000000000000000000000000000000000008152600481018390526060916001600160a01b03169063c87b56dd90602401600060405180830381865afa158015610aae573d6000803e3d6000fd5b505050506040513d6000823e601f3d908101601f191682016040526104639190810190611d77565b600082815260076020526040902060010154610af181610fea565b6105e08383611096565b610b036111c9565b6001600160a01b038116610b7f5760405162461bcd60e51b815260206004820152602660248201527f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160448201527f646472657373000000000000000000000000000000000000000000000000000060648201526084016105cc565b610b8881611223565b50565b60007fffffffff0000000000000000000000000000000000000000000000000000000082167f80ac58cd000000000000000000000000000000000000000000000000000000001480610c1e57507fffffffff0000000000000000000000000000000000000000000000000000000082167f5b5e139f00000000000000000000000000000000000000000000000000000000145b8061046357507f01ffc9a7000000000000000000000000000000000000000000000000000000007fffffffff00000000000000000000000000000000000000000000000000000000831614610463565b60007fffffffff0000000000000000000000000000000000000000000000000000000082167f7965db0b000000000000000000000000000000000000000000000000000000001480610463575061046382610b8b565b6000818152600260205260409020546001600160a01b0316610b885760405162461bcd60e51b815260206004820152601860248201527f4552433732313a20696e76616c696420746f6b656e204944000000000000000060448201526064016105cc565b600080610d3483610756565b9050806001600160a01b0316846001600160a01b03161480610d7b57506001600160a01b0380821660009081526005602090815260408083209388168352929052205460ff165b80610d9f5750836001600160a01b0316610d94846104fb565b6001600160a01b0316145b949350505050565b826001600160a01b0316610dba82610756565b6001600160a01b031614610e365760405162461bcd60e51b815260206004820152602560248201527f4552433732313a207472616e736665722066726f6d20696e636f72726563742060448201527f6f776e657200000000000000000000000000000000000000000000000000000060648201526084016105cc565b6001600160a01b038216610eb15760405162461bcd60e51b8152602060048201526024808201527f4552433732313a207472616e7366657220746f20746865207a65726f2061646460448201527f726573730000000000000000000000000000000000000000000000000000000060648201526084016105cc565b610ebe8383836001611325565b826001600160a01b0316610ed182610756565b6001600160a01b031614610f4d5760405162461bcd60e51b815260206004820152602560248201527f4552433732313a207472616e736665722066726f6d20696e636f72726563742060448201527f6f776e657200000000000000000000000000000000000000000000000000000060648201526084016105cc565b6000818152600460209081526040808320805473ffffffffffffffffffffffffffffffffffffffff199081169091556001600160a01b0387811680865260038552838620805460001901905590871680865283862080546001019055868652600290945282852080549092168417909155905184937fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef91a4505050565b610b888133611384565b60008281526007602090815260408083206001600160a01b038516845290915290205460ff166106925760008281526007602090815260408083206001600160a01b03851684529091529020805460ff191660011790556110523390565b6001600160a01b0316816001600160a01b0316837f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d60405160405180910390a45050565b60008281526007602090815260408083206001600160a01b038516845290915290205460ff16156106925760008281526007602090815260408083206001600160a01b0385168085529252808320805460ff1916905551339285917ff6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b9190a45050565b600061112482610756565b9050611134816000846001611325565b61113d82610756565b6000838152600460209081526040808320805473ffffffffffffffffffffffffffffffffffffffff199081169091556001600160a01b0385168085526003845282852080546000190190558785526002909352818420805490911690555192935084927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef908390a45050565b6006546001600160a01b031633146108675760405162461bcd60e51b815260206004820181905260248201527f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e657260448201526064016105cc565b600680546001600160a01b0383811673ffffffffffffffffffffffffffffffffffffffff19831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b6106928282604051806020016040528060008152506113f9565b6112a7848484610da7565b6112b384848484611482565b610a455760405162461bcd60e51b815260206004820152603260248201527f4552433732313a207472616e7366657220746f206e6f6e20455243373231526560448201527f63656976657220696d706c656d656e746572000000000000000000000000000060648201526084016105cc565b6001600160a01b0384161580159061134557506001600160a01b03831615155b1561137f576040517fcd4d8627000000000000000000000000000000000000000000000000000000008152600481018390526024016105cc565b610a45565b60008281526007602090815260408083206001600160a01b038516845290915290205460ff16610692576113b781611623565b6113c2836020611635565b6040516020016113d3929190611dee565b60408051601f198184030181529082905262461bcd60e51b82526105cc91600401611aa6565b6114038383611865565b6114106000848484611482565b6105e05760405162461bcd60e51b815260206004820152603260248201527f4552433732313a207472616e7366657220746f206e6f6e20455243373231526560448201527f63656976657220696d706c656d656e746572000000000000000000000000000060648201526084016105cc565b60006001600160a01b0384163b15611618576040517f150b7a020000000000000000000000000000000000000000000000000000000081526001600160a01b0385169063150b7a02906114df903390899088908890600401611e6f565b6020604051808303816000875af192505050801561151a575060408051601f3d908101601f1916820190925261151791810190611eab565b60015b6115cd573d808015611548576040519150601f19603f3d011682016040523d82523d6000602084013e61154d565b606091505b5080516000036115c55760405162461bcd60e51b815260206004820152603260248201527f4552433732313a207472616e7366657220746f206e6f6e20455243373231526560448201527f63656976657220696d706c656d656e746572000000000000000000000000000060648201526084016105cc565b805181602001fd5b7fffffffff00000000000000000000000000000000000000000000000000000000167f150b7a0200000000000000000000000000000000000000000000000000000000149050610d9f565b506001949350505050565b60606104636001600160a01b03831660145b60606000611644836002611ede565b61164f906002611ef5565b67ffffffffffffffff81111561166757611667611bd4565b6040519080825280601f01601f191660200182016040528015611691576020820181803683370190505b5090507f3000000000000000000000000000000000000000000000000000000000000000816000815181106116c8576116c8611f08565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a9053507f78000000000000000000000000000000000000000000000000000000000000008160018151811061172b5761172b611f08565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a9053506000611767846002611ede565b611772906001611ef5565b90505b600181111561180f577f303132333435363738396162636465660000000000000000000000000000000085600f16601081106117b3576117b3611f08565b1a60f81b8282815181106117c9576117c9611f08565b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535060049490941c9361180881611f1e565b9050611775565b50831561185e5760405162461bcd60e51b815260206004820181905260248201527f537472696e67733a20686578206c656e67746820696e73756666696369656e7460448201526064016105cc565b9392505050565b6001600160a01b0382166118bb5760405162461bcd60e51b815260206004820181905260248201527f4552433732313a206d696e7420746f20746865207a65726f206164647265737360448201526064016105cc565b6000818152600260205260409020546001600160a01b0316156119205760405162461bcd60e51b815260206004820152601c60248201527f4552433732313a20746f6b656e20616c7265616479206d696e7465640000000060448201526064016105cc565b61192e600083836001611325565b6000818152600260205260409020546001600160a01b0316156119935760405162461bcd60e51b815260206004820152601c60248201527f4552433732313a20746f6b656e20616c7265616479206d696e7465640000000060448201526064016105cc565b6001600160a01b0382166000818152600360209081526040808320805460010190558483526002909152808220805473ffffffffffffffffffffffffffffffffffffffff19168417905551839291907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef908290a45050565b7fffffffff0000000000000000000000000000000000000000000000000000000081168114610b8857600080fd5b600060208284031215611a4b57600080fd5b813561185e81611a0b565b60005b83811015611a71578181015183820152602001611a59565b50506000910152565b60008151808452611a92816020860160208601611a56565b601f01601f19169290920160200192915050565b60208152600061185e6020830184611a7a565b600060208284031215611acb57600080fd5b5035919050565b6001600160a01b0381168114610b8857600080fd5b60008060408385031215611afa57600080fd5b8235611b0581611ad2565b946020939093013593505050565b600080600060608486031215611b2857600080fd5b8335611b3381611ad2565b92506020840135611b4381611ad2565b929592945050506040919091013590565b60008060408385031215611b6757600080fd5b823591506020830135611b7981611ad2565b809150509250929050565b600060208284031215611b9657600080fd5b813561185e81611ad2565b60008060408385031215611bb457600080fd5b8235611bbf81611ad2565b915060208301358015158114611b7957600080fd5b634e487b7160e01b600052604160045260246000fd5b604051601f8201601f1916810167ffffffffffffffff81118282101715611c1357611c13611bd4565b604052919050565b600067ffffffffffffffff821115611c3557611c35611bd4565b50601f01601f191660200190565b60008060008060808587031215611c5957600080fd5b8435611c6481611ad2565b93506020850135611c7481611ad2565b925060408501359150606085013567ffffffffffffffff811115611c9757600080fd5b8501601f81018713611ca857600080fd5b8035611cbb611cb682611c1b565b611bea565b818152886020838501011115611cd057600080fd5b8160208401602083013760006020838301015280935050505092959194509250565b60008060408385031215611d0557600080fd5b8235611d1081611ad2565b91506020830135611b7981611ad2565b600181811c90821680611d3457607f821691505b602082108103611d5457634e487b7160e01b600052602260045260246000fd5b50919050565b600060208284031215611d6c57600080fd5b815161185e81611ad2565b600060208284031215611d8957600080fd5b815167ffffffffffffffff811115611da057600080fd5b8201601f81018413611db157600080fd5b8051611dbf611cb682611c1b565b818152856020838501011115611dd457600080fd5b611de5826020830160208601611a56565b95945050505050565b7f416363657373436f6e74726f6c3a206163636f756e7420000000000000000000815260008351611e26816017850160208801611a56565b7f206973206d697373696e6720726f6c65200000000000000000000000000000006017918401918201528351611e63816028840160208801611a56565b01602801949350505050565b60006001600160a01b03808716835280861660208401525083604083015260806060830152611ea16080830184611a7a565b9695505050505050565b600060208284031215611ebd57600080fd5b815161185e81611a0b565b634e487b7160e01b600052601160045260246000fd5b808202811582820484141761046357610463611ec8565b8082018082111561046357610463611ec8565b634e487b7160e01b600052603260045260246000fd5b600081611f2d57611f2d611ec8565b50600019019056fea2646970667358221220a47a730532362f23cd6ea07cbffa4e18e194e7d07e15a6dd7d0230e8c8941bf764736f6c63430008110033";

type SoulboundFoundersKeyConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: SoulboundFoundersKeyConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class SoulboundFoundersKey__factory extends ContractFactory {
  constructor(...args: SoulboundFoundersKeyConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    _foundersKeysAddress: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<SoulboundFoundersKey> {
    return super.deploy(
      _foundersKeysAddress,
      overrides || {}
    ) as Promise<SoulboundFoundersKey>;
  }
  override getDeployTransaction(
    _foundersKeysAddress: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(_foundersKeysAddress, overrides || {});
  }
  override attach(address: string): SoulboundFoundersKey {
    return super.attach(address) as SoulboundFoundersKey;
  }
  override connect(signer: Signer): SoulboundFoundersKey__factory {
    return super.connect(signer) as SoulboundFoundersKey__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): SoulboundFoundersKeyInterface {
    return new utils.Interface(_abi) as SoulboundFoundersKeyInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): SoulboundFoundersKey {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as SoulboundFoundersKey;
  }
}