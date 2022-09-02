/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  ERC721A,
  ERC721AInterface,
} from "../../../../erc721a/contracts/ERC721A.sol/ERC721A";

const _abi = [
  {
    inputs: [
      {
        internalType: "string",
        name: "name_",
        type: "string",
      },
      {
        internalType: "string",
        name: "symbol_",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "ApprovalCallerNotOwnerNorApproved",
    type: "error",
  },
  {
    inputs: [],
    name: "ApprovalQueryForNonexistentToken",
    type: "error",
  },
  {
    inputs: [],
    name: "ApproveToCaller",
    type: "error",
  },
  {
    inputs: [],
    name: "BalanceQueryForZeroAddress",
    type: "error",
  },
  {
    inputs: [],
    name: "MintERC2309QuantityExceedsLimit",
    type: "error",
  },
  {
    inputs: [],
    name: "MintToZeroAddress",
    type: "error",
  },
  {
    inputs: [],
    name: "MintZeroQuantity",
    type: "error",
  },
  {
    inputs: [],
    name: "OwnerQueryForNonexistentToken",
    type: "error",
  },
  {
    inputs: [],
    name: "OwnershipNotInitializedForExtraData",
    type: "error",
  },
  {
    inputs: [],
    name: "TransferCallerNotOwnerNorApproved",
    type: "error",
  },
  {
    inputs: [],
    name: "TransferFromIncorrectOwner",
    type: "error",
  },
  {
    inputs: [],
    name: "TransferToNonERC721ReceiverImplementer",
    type: "error",
  },
  {
    inputs: [],
    name: "TransferToZeroAddress",
    type: "error",
  },
  {
    inputs: [],
    name: "URIQueryForNonexistentToken",
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
        indexed: true,
        internalType: "uint256",
        name: "fromTokenId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "toTokenId",
        type: "uint256",
      },
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
    ],
    name: "ConsecutiveTransfer",
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
    inputs: [
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
        name: "_data",
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
    inputs: [],
    name: "totalSupply",
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
];

const _bytecode =
  "0x60806040523480156200001157600080fd5b5060405162001cf738038062001cf78339818101604052810190620000379190620002d9565b81600290805190602001906200004f9291906200008c565b508060039080519060200190620000689291906200008c565b50620000796200008760201b60201c565b6000819055505050620003c3565b600090565b8280546200009a906200038d565b90600052602060002090601f016020900481019282620000be57600085556200010a565b82601f10620000d957805160ff19168380011785556200010a565b828001600101855582156200010a579182015b8281111562000109578251825591602001919060010190620000ec565b5b5090506200011991906200011d565b5090565b5b80821115620001385760008160009055506001016200011e565b5090565b6000604051905090565b600080fd5b600080fd5b600080fd5b600080fd5b6000601f19601f8301169050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b620001a5826200015a565b810181811067ffffffffffffffff82111715620001c757620001c66200016b565b5b80604052505050565b6000620001dc6200013c565b9050620001ea82826200019a565b919050565b600067ffffffffffffffff8211156200020d576200020c6200016b565b5b62000218826200015a565b9050602081019050919050565b60005b838110156200024557808201518184015260208101905062000228565b8381111562000255576000848401525b50505050565b6000620002726200026c84620001ef565b620001d0565b90508281526020810184848401111562000291576200029062000155565b5b6200029e84828562000225565b509392505050565b600082601f830112620002be57620002bd62000150565b5b8151620002d08482602086016200025b565b91505092915050565b60008060408385031215620002f357620002f262000146565b5b600083015167ffffffffffffffff8111156200031457620003136200014b565b5b6200032285828601620002a6565b925050602083015167ffffffffffffffff8111156200034657620003456200014b565b5b6200035485828601620002a6565b9150509250929050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b60006002820490506001821680620003a657607f821691505b60208210811415620003bd57620003bc6200035e565b5b50919050565b61192480620003d36000396000f3fe608060405234801561001057600080fd5b50600436106100ea5760003560e01c80636352211e1161008c578063a22cb46511610066578063a22cb4651461025d578063b88d4fde14610279578063c87b56dd14610295578063e985e9c5146102c5576100ea565b80636352211e146101df57806370a082311461020f57806395d89b411461023f576100ea565b8063095ea7b3116100c8578063095ea7b31461016d57806318160ddd1461018957806323b872dd146101a757806342842e0e146101c3576100ea565b806301ffc9a7146100ef57806306fdde031461011f578063081812fc1461013d575b600080fd5b610109600480360381019061010491906111f3565b6102f5565b604051610116919061123b565b60405180910390f35b610127610387565b60405161013491906112ef565b60405180910390f35b61015760048036038101906101529190611347565b610419565b60405161016491906113b5565b60405180910390f35b610187600480360381019061018291906113fc565b610498565b005b6101916105dc565b60405161019e919061144b565b60405180910390f35b6101c160048036038101906101bc9190611466565b6105f3565b005b6101dd60048036038101906101d89190611466565b610918565b005b6101f960048036038101906101f49190611347565b610938565b60405161020691906113b5565b60405180910390f35b610229600480360381019061022491906114b9565b61094a565b604051610236919061144b565b60405180910390f35b610247610a03565b60405161025491906112ef565b60405180910390f35b61027760048036038101906102729190611512565b610a95565b005b610293600480360381019061028e9190611687565b610c0d565b005b6102af60048036038101906102aa9190611347565b610c80565b6040516102bc91906112ef565b60405180910390f35b6102df60048036038101906102da919061170a565b610d1f565b6040516102ec919061123b565b60405180910390f35b60006301ffc9a760e01b827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916148061035057506380ac58cd60e01b827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916145b806103805750635b5e139f60e01b827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916145b9050919050565b60606002805461039690611779565b80601f01602080910402602001604051908101604052809291908181526020018280546103c290611779565b801561040f5780601f106103e45761010080835404028352916020019161040f565b820191906000526020600020905b8154815290600101906020018083116103f257829003601f168201915b5050505050905090565b600061042482610db3565b61045a576040517fcf4700e400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6006600083815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b60006104a382610938565b90508073ffffffffffffffffffffffffffffffffffffffff166104c4610e12565b73ffffffffffffffffffffffffffffffffffffffff1614610527576104f0816104eb610e12565b610d1f565b610526576040517fcfb3b94200000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b826006600084815260200190815260200160002060000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550818373ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92560405160405180910390a4505050565b60006105e6610e1a565b6001546000540303905090565b60006105fe82610e1f565b90508373ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614610665576040517fa114810000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60008061067184610eed565b915091506106878187610682610e12565b610f14565b6106d35761069c86610697610e12565b610d1f565b6106d2576040517f59c896be00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b600073ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff16141561073a576040517fea553b3400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6107478686866001610f58565b801561075257600082555b600560008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600081546001900391905081905550600560008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000815460010191905081905550610820856107fc888887610f5e565b7c020000000000000000000000000000000000000000000000000000000017610f86565b600460008681526020019081526020016000208190555060007c0200000000000000000000000000000000000000000000000000000000841614156108a85760006001850190506000600460008381526020019081526020016000205414156108a65760005481146108a5578360046000838152602001908152602001600020819055505b5b505b838573ffffffffffffffffffffffffffffffffffffffff168773ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60405160405180910390a46109108686866001610fb1565b505050505050565b61093383838360405180602001604052806000815250610c0d565b505050565b600061094382610e1f565b9050919050565b60008073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614156109b2576040517f8f4eb60400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b67ffffffffffffffff600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054169050919050565b606060038054610a1290611779565b80601f0160208091040260200160405190810160405280929190818152602001828054610a3e90611779565b8015610a8b5780601f10610a6057610100808354040283529160200191610a8b565b820191906000526020600020905b815481529060010190602001808311610a6e57829003601f168201915b5050505050905090565b610a9d610e12565b73ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff161415610b02576040517fb06307db00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b8060076000610b0f610e12565b73ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff0219169083151502179055508173ffffffffffffffffffffffffffffffffffffffff16610bbc610e12565b73ffffffffffffffffffffffffffffffffffffffff167f17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c3183604051610c01919061123b565b60405180910390a35050565b610c188484846105f3565b60008373ffffffffffffffffffffffffffffffffffffffff163b14610c7a57610c4384848484610fb7565b610c79576040517fd1a57ed600000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b50505050565b6060610c8b82610db3565b610cc1576040517fa14c4b5000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6000610ccb611117565b9050600081511415610cec5760405180602001604052806000815250610d17565b80610cf68461112e565b604051602001610d079291906117e7565b6040516020818303038152906040525b915050919050565b6000600760008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16905092915050565b600081610dbe610e1a565b11158015610dcd575060005482105b8015610e0b575060007c0100000000000000000000000000000000000000000000000000000000600460008581526020019081526020016000205416145b9050919050565b600033905090565b600090565b60008082905080610e2e610e1a565b11610eb657600054811015610eb55760006004600083815260200190815260200160002054905060007c010000000000000000000000000000000000000000000000000000000082161415610eb3575b6000811415610ea9576004600083600190039350838152602001908152602001600020549050610e7e565b8092505050610ee8565b505b5b6040517fdf2d9b4200000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b919050565b60008060006006600085815260200190815260200160002090508092508254915050915091565b600073ffffffffffffffffffffffffffffffffffffffff8316925073ffffffffffffffffffffffffffffffffffffffff821691508382148383141790509392505050565b50505050565b60008060e883901c905060e8610f7586868461117e565b62ffffff16901b9150509392505050565b600073ffffffffffffffffffffffffffffffffffffffff83169250814260a01b178317905092915050565b50505050565b60008373ffffffffffffffffffffffffffffffffffffffff1663150b7a02610fdd610e12565b8786866040518563ffffffff1660e01b8152600401610fff9493929190611860565b602060405180830381600087803b15801561101957600080fd5b505af192505050801561104a57506040513d601f19601f8201168201806040525081019061104791906118c1565b60015b6110c4573d806000811461107a576040519150601f19603f3d011682016040523d82523d6000602084013e61107f565b606091505b506000815114156110bc576040517fd1a57ed600000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b805181602001fd5b63150b7a0260e01b7bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916817bffffffffffffffffffffffffffffffffffffffffffffffffffffffff191614915050949350505050565b606060405180602001604052806000815250905090565b606060806040510190508060405280825b60011561116a57600183039250600a81066030018353600a81049050806111655761116a565b61113f565b508181036020830392508083525050919050565b60009392505050565b6000604051905090565b600080fd5b600080fd5b60007fffffffff0000000000000000000000000000000000000000000000000000000082169050919050565b6111d08161119b565b81146111db57600080fd5b50565b6000813590506111ed816111c7565b92915050565b60006020828403121561120957611208611191565b5b6000611217848285016111de565b91505092915050565b60008115159050919050565b61123581611220565b82525050565b6000602082019050611250600083018461122c565b92915050565b600081519050919050565b600082825260208201905092915050565b60005b83811015611290578082015181840152602081019050611275565b8381111561129f576000848401525b50505050565b6000601f19601f8301169050919050565b60006112c182611256565b6112cb8185611261565b93506112db818560208601611272565b6112e4816112a5565b840191505092915050565b6000602082019050818103600083015261130981846112b6565b905092915050565b6000819050919050565b61132481611311565b811461132f57600080fd5b50565b6000813590506113418161131b565b92915050565b60006020828403121561135d5761135c611191565b5b600061136b84828501611332565b91505092915050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600061139f82611374565b9050919050565b6113af81611394565b82525050565b60006020820190506113ca60008301846113a6565b92915050565b6113d981611394565b81146113e457600080fd5b50565b6000813590506113f6816113d0565b92915050565b6000806040838503121561141357611412611191565b5b6000611421858286016113e7565b925050602061143285828601611332565b9150509250929050565b61144581611311565b82525050565b6000602082019050611460600083018461143c565b92915050565b60008060006060848603121561147f5761147e611191565b5b600061148d868287016113e7565b935050602061149e868287016113e7565b92505060406114af86828701611332565b9150509250925092565b6000602082840312156114cf576114ce611191565b5b60006114dd848285016113e7565b91505092915050565b6114ef81611220565b81146114fa57600080fd5b50565b60008135905061150c816114e6565b92915050565b6000806040838503121561152957611528611191565b5b6000611537858286016113e7565b9250506020611548858286016114fd565b9150509250929050565b600080fd5b600080fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b611594826112a5565b810181811067ffffffffffffffff821117156115b3576115b261155c565b5b80604052505050565b60006115c6611187565b90506115d2828261158b565b919050565b600067ffffffffffffffff8211156115f2576115f161155c565b5b6115fb826112a5565b9050602081019050919050565b82818337600083830152505050565b600061162a611625846115d7565b6115bc565b90508281526020810184848401111561164657611645611557565b5b611651848285611608565b509392505050565b600082601f83011261166e5761166d611552565b5b813561167e848260208601611617565b91505092915050565b600080600080608085870312156116a1576116a0611191565b5b60006116af878288016113e7565b94505060206116c0878288016113e7565b93505060406116d187828801611332565b925050606085013567ffffffffffffffff8111156116f2576116f1611196565b5b6116fe87828801611659565b91505092959194509250565b6000806040838503121561172157611720611191565b5b600061172f858286016113e7565b9250506020611740858286016113e7565b9150509250929050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b6000600282049050600182168061179157607f821691505b602082108114156117a5576117a461174a565b5b50919050565b600081905092915050565b60006117c182611256565b6117cb81856117ab565b93506117db818560208601611272565b80840191505092915050565b60006117f382856117b6565b91506117ff82846117b6565b91508190509392505050565b600081519050919050565b600082825260208201905092915050565b60006118328261180b565b61183c8185611816565b935061184c818560208601611272565b611855816112a5565b840191505092915050565b600060808201905061187560008301876113a6565b61188260208301866113a6565b61188f604083018561143c565b81810360608301526118a18184611827565b905095945050505050565b6000815190506118bb816111c7565b92915050565b6000602082840312156118d7576118d6611191565b5b60006118e5848285016118ac565b9150509291505056fea264697066735822122005b7f0cec5ac83b6682186e81d0e357fcae87d11dac011b67bc6c2552bec340d64736f6c63430008090033";

type ERC721AConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: ERC721AConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class ERC721A__factory extends ContractFactory {
  constructor(...args: ERC721AConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    name_: PromiseOrValue<string>,
    symbol_: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ERC721A> {
    return super.deploy(name_, symbol_, overrides || {}) as Promise<ERC721A>;
  }
  override getDeployTransaction(
    name_: PromiseOrValue<string>,
    symbol_: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(name_, symbol_, overrides || {});
  }
  override attach(address: string): ERC721A {
    return super.attach(address) as ERC721A;
  }
  override connect(signer: Signer): ERC721A__factory {
    return super.connect(signer) as ERC721A__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): ERC721AInterface {
    return new utils.Interface(_abi) as ERC721AInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ERC721A {
    return new Contract(address, _abi, signerOrProvider) as ERC721A;
  }
}
