/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  ERC721A__IERC721Receiver,
  ERC721A__IERC721ReceiverInterface,
} from "../../../../contracts/tokens/ERC721A.sol/ERC721A__IERC721Receiver";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        internalType: "address",
        name: "from",
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
    name: "onERC721Received",
    outputs: [
      {
        internalType: "bytes4",
        name: "",
        type: "bytes4",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class ERC721A__IERC721Receiver__factory {
  static readonly abi = _abi;
  static createInterface(): ERC721A__IERC721ReceiverInterface {
    return new utils.Interface(_abi) as ERC721A__IERC721ReceiverInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ERC721A__IERC721Receiver {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as ERC721A__IERC721Receiver;
  }
}
