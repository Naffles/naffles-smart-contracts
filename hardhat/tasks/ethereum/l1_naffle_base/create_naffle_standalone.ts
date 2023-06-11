import { task } from "hardhat/config"
import * as ethers from "ethers";;
import { Contract, Wallet, Provider, utils } from "zksync-web3";

import dotenv from "dotenv";
dotenv.config();

const L2_RPC_ENDPOINT = "https://goerli-api.zksync.io/jsrpc";

const WALLET_PRIV_KEY = process.env.PRIVATE_KEY || "";

if (!WALLET_PRIV_KEY) {
  throw new Error("Wallet private key is not configured in env file");
}

const INFURA_API_KEY = process.env.INFURA_API_KEY || "";
const infura_url = "https://goerli.infura.io/v3/" + INFURA_API_KEY


async function main() {
  const l2provider = new Provider(L2_RPC_ENDPOINT);
  const l1provider = new Provider(infura_url);

  const walletL2 = new ethers.Wallet(WALLET_PRIV_KEY, l2provider);
  const l2NaffleBaseAbi = require('./../../../artifacts/contracts/naffle/zksync/L2NaffleBase.sol/L2NaffleBase.json').abi;
  const l2NaffleBaseInstance = new Contract("0x44034Cb44244137AD978C01Ec2d708a3f9444C8e", l2NaffleBaseAbi, walletL2);



  console.log("Setting approval for the nft contract...")
  // const approve_tx = await nftContractInstance.setApprovalForAll("0xF064985875ad51f15f77F5B8f4BC80cA578deedc", true);
  // await approve_tx.wait();


  const nftcontractaddress = "0x8Bc8fAFD87f0eDa7107dc989ae276Cb8f53b365d"
  const nftId = 1
  const paidTicketSpots = 200
  const ticketPriceInWei = ethers.utils.parseEther("0.001")
  const endTime = Math.floor(Date.now() / 1000) + 604800
  const naffleType = 0
  const naffleTokenType = 0


  const l2Params = {
      ethTokenAddress: nftcontractaddress,
      owner: walletL2.address,
      naffleId: 1,
      nftId: nftId,
      paidTicketSpots: paidTicketSpots,
      ticketPriceInWei: ticketPriceInWei,
      endTime: endTime,
      naffleType: naffleType,
      naffleTokenType: naffleType
  }

  console.log("Preparing transaction")

  const prepareTransaction = await l2NaffleBaseInstance.connect(walletL2).populateTransaction.createNaffle(
    l2Params
  )

  console.log(prepareTransaction)

  const l2GasLimit = await l2provider.estimateGasL1(prepareTransaction)
  console.log("l2GasLimit: ", l2GasLimit.toString());


  const walletL1 = new ethers.Wallet(WALLET_PRIV_KEY, l1provider);

  const l1GasPrice = await l1provider.getGasPrice();
  console.log(`L1 gasPrice ${ethers.utils.formatEther(l1GasPrice)} ETH`);

  console.log(`l1 network: ${await l1provider.getNetwork()}`);

  const erc721AMockAbi = require('./../../../artifacts/contracts/mocks/ERC721AMock.sol/ERC721AMock.json').abi;
  const l1NaffleBaseAbi = require('./../../../artifacts/contracts/naffle/ethereum/L1NaffleBase.sol/L1NaffleBase.json').abi;
  const nftContractInstance = new ethers.Contract("0xFb6598626868D3427D349891032c9bb34eabAc20", erc721AMockAbi, walletL1);
  const l1NaffleBaseInstance = new ethers.Contract("0xAC9f605F0637515a213a6d36C8F3B3D5F3D6382B", l1NaffleBaseAbi, walletL1);


  const zksyncWallet = new Wallet(WALLET_PRIV_KEY, l2provider);
  const baseCost = await zksyncWallet.getBaseCost({
    // L2 computation
    gasLimit: l2GasLimit,
    // L1 gas price
    gasPrice: l1GasPrice,
  });


  console.log("DONE")
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

//
// const l2ContractFactory = await ethers.getContractFactory("L2NaffleBase");
// const walletL1 = new ethers.Wallet(WALLET_PRIV_KEY, l1provider);
//
// const erc721AMockAbi = require('./../../../artifacts/contracts/mocks/ERC721AMock.sol/ERC721AMock.json').abi;
// const nftContractInstance = new ethers.Contract(taskArgs.nftcontractaddress, erc721AMockAbi, walletL1);
// const approve_tx = await nftContractInstance.connect(walletL1).setApprovalForAll(taskArgs.l1nafflecontractaddress, true);
// const approve_receipt = await approve_tx.wait();
// console.log("approve_receipt: ", approve_receipt);
//
//     const l2ContractInstance = l2ContractFactory.attach(taskArgs.l2nafflecontractaddress);
//     // const nftContractInstance = nftContractFactory.attach(taskArgs.nftcontractaddress);
//
//     const nftId = parseInt(taskArgs.nfttokenid)
//     const paidTicketSpots = parseInt(taskArgs.ticketspots)
//     const ticketPriceInWei = ethers.utils.parseEther("0.001")
//     const endTime = Math.floor(Date.now() / 1000) + 604800
//     const naffleType = parseInt(taskArgs.naffletype)
//     const naffleTokenType = 0
//
//     const next_week = Math.floor(Date.now() / 1000) + 604800;
//
//
//
//   try {
//
//
//     const l2Params = {
//       ethTokenAddress: taskArgs.nftcontractaddress,
//       owner: signers[0].address,
//       naffleId: 1,
//       nftId: nftId,
//       paidTicketSpots: paidTicketSpots,
//       ticketPriceInWei: ticketPriceInWei,
//       endTime: endTime,
//       naffleType: naffleType,
//       naffleTokenType: naffleType
//     }
//
//     console.log("Preparing transaction")
//
//     const prepareTransaction = await l2ContractInstance.populateTransaction.createNaffle(
//       l2Params
//     )
//
//     console.log(prepareTransaction)
//
//
//     const l2GasLimit = await l2provider.estimateGasL1(prepareTransaction)
//
//     console.log("l2GasLimit: ", l2GasLimit.toString());
//
//     const baseCost = await walletL2.getBaseCost({
//       // L2 computation
//       gasLimit: l2GasLimit,
//       // L1 gas price
//       gasPrice: l1GasPrice,
//     });
//
//     console.log("baseCost: ", baseCost.toString());
//
//     const contractFactory = await ethers.getContractFactory("L1NaffleBase");
//     const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
//
//     // Send the transaction【13†source】
//     const tx = await contractInstance.createNaffle(
//       taskArgs.nftcontractaddress,
//       nftId,
//       paidTicketSpots,
//       ticketPriceInWei,
//       endTime,
//       naffleType,
//       {
//         l2GasLimit: l2GasLimit,
//         l2GasPerPubdataByteLimit: utils.REQUIRED_L1_TO_L2_GAS_PER_PUBDATA_LIMIT
//       },
//       {
//         value: baseCost.add(l1GasPrice.mul(l2GasLimit))
//       }
//     );
//
//     const receipt = await tx.wait();
//     console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
//   } catch (error) {
//     console.error(`Error in transaction: ${error}`);
//   }
//   });
