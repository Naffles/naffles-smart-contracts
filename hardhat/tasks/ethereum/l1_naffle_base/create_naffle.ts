import { task } from "hardhat/config"
import {type BigNumber} from "ethers";
import { Contract, Wallet, Provider, utils } from "zksync-web3";
import * as ethers from "ethers";

const L2_RPC_ENDPOINT = "https://goerli-api.zksync.io/jsrpc";

task("create-naffle", "Creates a naffle on the L1 contract")
    .addParam("l1nafflecontractaddress", "L1 naffle diamond contract address")
    .addParam("l2nafflecontractaddress", "L2 naffle diamond contract address")
    .addParam("nftcontractaddress", "contract address of nft to naffle")
    .addParam("nfttokenid", "token id of nft to naffle")
    .addParam("ticketspots", "amount")
    // .addParam("endtimestamp", "end timestamp")
    .addParam("naffletype", "naffle type, 0 for standard, 1 for unlimited")
    .setAction(async (taskArgs, hre) => {
      const WALLET_PRIV_KEY = process.env.PRIVATE_KEY || "";

      if (!WALLET_PRIV_KEY) {
          throw new Error("Wallet private key is not configured in env file");
      }

    const signers = await hre.ethers.getSigners()

    const INFURA_API_KEY = process.env.INFURA_API_KEY || "";

    const infura_url = "https://goerli.infura.io/v3/" + INFURA_API_KEY

    // const l2provider = new Provider(L2_RPC_ENDPOINT);

    // const walletL2 = new Wallet(WALLET_PRIV_KEY, l2provider, l1provider);
    // const walletL1 = new hre.ethers.Wallet(WALLET_PRIV_KEY, l1provider);

    const l1GasPrice = await hre.ethers.provider.getGasPrice();
    console.log(`L1 gasPrice ${ethers.utils.formatEther(l1GasPrice)} ETH`);

    console.log(`l1 network: ${await hre.ethers.provider.getNetwork()}`);

    // const erc721AMockAbi = require('./../../../artifacts/contracts/mocks/ERC721AMock.sol/ERC721AMock.json').abi;
    // const nftContractInstance = new hre.ethers.Contract(taskArgs.nftcontractaddress, erc721AMockAbi, walletL1);
    const contractFactory = await hre.ethers.getContractFactory("ERC721AMock");
    const nftContractInstance = contractFactory.attach(taskArgs.nftcontractaddress);
    const approve_tx = await nftContractInstance.setApprovalForAll(taskArgs.l1nafflecontractaddress, true);
    const approve_receipt = await approve_tx.wait();
    console.log("approve_receipt: ", approve_receipt);

    console.log("DONE")


    // console.log(`l2 network: ${await l2provider.getNetwork()}`);

    const l2ContractFactory = await hre.ethers.getContractFactory("L2NaffleBase");


    const l2ContractInstance = l2ContractFactory.attach(taskArgs.l2nafflecontractaddress);
    // const nftContractInstance = nftContractFactory.attach(taskArgs.nftcontractaddress);

    const nftId = parseInt(taskArgs.nfttokenid)
    const paidTicketSpots = parseInt(taskArgs.ticketspots)
    const ticketPriceInWei = hre.ethers.utils.parseEther("0.001")
    const endTime = Math.floor(Date.now() / 1000) + 604800
    const naffleType = parseInt(taskArgs.naffletype)
    const naffleTokenType = 0

    const next_week = Math.floor(Date.now() / 1000) + 604800;



    try {
      const l2Params = {
          ethTokenAddress: taskArgs.nftcontractaddress,
          owner: signers[0].address,
          naffleId: 1,
          nftId: nftId,
          paidTicketSpots: paidTicketSpots,
          ticketPriceInWei: ticketPriceInWei,
          endTime: endTime,
          naffleType: naffleType,
          naffleTokenType: naffleType
      }

      console.log("Preparing transaction")

      const prepareTransaction = await l2ContractInstance.populateTransaction.createNaffle(
          l2Params
      )

      console.log(prepareTransaction)


      // const l2GasLimit = await l2provider.estimateGasL1(prepareTransaction)

      // console.log("l2GasLimit: ", l2GasLimit.toString());

      // const baseCost = await walletL2.getBaseCost({
      //     // L2 computation
      //     gasLimit: l2GasLimit,
      //     // L1 gas price
      //     gasPrice: l1GasPrice,
      // });


      const contractFactory = await hre.ethers.getContractFactory("L1NaffleBase");
      const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);

      console.log("SENDING CREATE NAFFLE ")
      const tx = await contractInstance.createNaffle(
          taskArgs.nftcontractaddress,
          nftId,
          paidTicketSpots,
          ticketPriceInWei,
          endTime,
          naffleType,
          {
              l2GasLimit: 100000,
              l2GasPerPubdataByteLimit: utils.REQUIRED_L1_TO_L2_GAS_PER_PUBDATA_LIMIT
          },
          {
              // value: baseCost.add(l1GasPrice.mul(l2GasLimit))
            value: hre.ethers.utils.parseEther("1")
          }
        );

        const receipt = await tx.wait();
        console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
      } catch (error) {
        console.error(`Error in transaction: ${error}`);
      }


        // --- old code
        // const contractFactory = await hre.ethers.getContractFactory("L1NaffleBase");
        // const nftContractFactory = await hre.ethers.getContractFactory("ERC721AMock");
        // const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
        // const nftContractInstance = nftContractFactory.attach(taskArgs.nftcontractaddress);
        //
        // // set approval for naffle contract to transfer nft
        // const approve_tx = await nftContractInstance.setApprovalForAll(taskArgs.l1nafflecontractaddress, true);
        // const approve_receipt = await approve_tx.wait();
        //
        // const next_week = Math.floor(Date.now() / 1000) + 604800
        // console.log(next_week)
        // try {
        //     const tx = await contractInstance.createNaffle(
        //         taskArgs.nftcontractaddress,
        //         taskArgs.nfttokenid,
        //         taskArgs.ticketspots,
        //         hre.ethers.utils.parseEther("0.001"),
        //         next_week,
        //         taskArgs.naffletype
        //         // extra gas info in the following format
        //     //         struct L2MessageParams {
        //         //         uint256 l2GasLimit;
        //         //         uint256 l2GasPerPubdataByteLimit;
        //         //     }
        //     );
        //     const receipt = await tx.wait();
        //     console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
        // } catch (e) {
        //     console.log(e)
        // }

    });
