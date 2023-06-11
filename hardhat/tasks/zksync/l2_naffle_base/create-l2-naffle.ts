// IZkSync zksync = IZkSync(layout.zkSyncAddress);
// NaffleTypes.CreateZkSyncNaffleParams memory params = NaffleTypes.CreateZkSyncNaffleParams({
//   ethTokenAddress: _ethTokenAddress,
//   owner: msg.sender,
//   naffleId: naffleId,
//   nftId: _nftId,
//   paidTicketSpots: _paidTicketSpots,
//   ticketPriceInWei: _ticketPriceInWei,
//   endTime: _endTime,
//   naffleType: _naffleType,
//   naffleTokenType: tokenContractType
// });
//
// txHash = zksync.requestL2Transaction{value: msg.value}(
//   layout.zkSyncNaffleContractAddress,
//     0,
//     abi.encodeWithSignature(
//       "createNaffle((address, address, uint256, uint256, uint256, uint256, uint256, uint8, uint8))",
//       params
//     ),
//     _l2MessageParams.l2GasLimit,
//     _l2MessageParams.l2GasPerPubdataByteLimit,
//     new bytes[](0),
//     msg.sender
// );


import { task } from "hardhat/config"
import {type BigNumber} from "ethers";
import { Contract, Wallet, Provider, utils, } from "zksync-web3";
import * as ethers from "ethers";

const ABI = [
  {
    inputs: [
      {
        internalType: "string",
        name: "_greeting",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "greet",
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
        internalType: "string",
        name: "_greeting",
        type: "string",
      },
    ],
    name: "setGreeting",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

task("create-l2-naffle", "Creates naffle on l2 as test")
  .addParam("l2nafflecontractaddress", "L2 naffle diamond contract address")
  .addParam("nftcontractaddress", "contract address of nft to naffle")
  .addParam("nfttokenid", "token id of nft to naffle")
  .addParam("ticketspots", "amount")
  .addParam("naffletype", "naffle type, 0 for standard, 1 for unlimited")
  .setAction(async (taskArgs, hre) => {
    const WALLET_PRIV_KEY = process.env.PRIVATE_KEY || "";

    if (!WALLET_PRIV_KEY) {
        throw new Error("Wallet private key is not configured in env file");
    }

    if (!WALLET_PRIV_KEY) {
      throw new Error("Wallet private key is not configured in env file");
    }

    const INFURA_API_KEY = process.env.INFURA_API_KEY || "";
    // const L2_RPC_ENDPOINT = "https://goerli-api.zksync.io/jsrpc";
    const L2_RPC_ENDPOINT = "https://testnet.era.zksync.dev"
    const infura_url = "https://goerli.infura.io/v3/" + INFURA_API_KEY
    console.log("infura url: " + infura_url)

    const l1provider = new Provider(infura_url);
    const l2provider = new Provider(L2_RPC_ENDPOINT);

    const walletL2 = new Wallet(WALLET_PRIV_KEY, l2provider, l1provider);

    const abi = require('./../../../artifacts/contracts/naffle/zksync/L2NaffleBase.sol/L2NaffleBase.json').abi;
    const l2ContractInstance = new Contract(taskArgs.l2nafflecontractaddress, abi, walletL2);

    console.log("SETTING l1 contract to this wallet")
    const contractFactory = await hre.ethers.getContractFactory("L2NaffleAdmin");
    const l2ContractAdminInstance = contractFactory.attach(taskArgs.l2nafflecontractaddress);

    const transaction = await l2ContractAdminInstance.connect(walletL2).setL1NaffleContractAddress(walletL2.address)
    const tx = await transaction.wait()

    console.log("SET l1 contract to this wallet")

    const endTime = Math.floor(Date.now() / 1000) + 604800
    const l2Params = {
        ethTokenAddress: taskArgs.nftcontractaddress,
        owner: walletL2.address,
        naffleId: 1,
        nftId: 1,
        paidTicketSpots: 200,
        ticketPriceInWei: hre.ethers.utils.parseEther("0.001"),
        endTime: endTime,
        naffleType: 0,
        naffleTokenType: 0
    }

      console.log("Preparing transaction")

      const prepareTransaction = await l2ContractInstance.connect(walletL2).populateTransaction.createNaffle(
        l2Params
      )
      console.log(prepareTransaction)
    //
    // const prepareTransaction = {
    //   data: '0x86665093000000000000000000000000ae4efd482e3d94e2c6f4330c1a293c7b758814c200000000000000000000000077d373d69bd7a55e0bbdf6cd290083cfe11643c40000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c800000000000000000000000000000000000000000000000000038d7ea4c6800000000000000000000000000000000000000000000000000000000000648ef31800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
    //   to: '0xD71f9c07bd63Fe3Dcc6d542BD59ea897fc581F17'
    // }

      console.log("***")


      const l2GasLimit = await l2provider.estimateGasL1(prepareTransaction)
      console.log("l2GasLimit", l2GasLimit)
  }
);