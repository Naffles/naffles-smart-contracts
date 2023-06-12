import { task } from "hardhat/config"
import { Wallet, Provider, utils } from "zksync-web3";
import {getInfuraURL, getPrivateKey, getRPCEndpoint} from "../../../util";


task("create-naffle", "Creates a naffle on the L1 contract")
  .addParam("l1nafflecontractaddress", "The Ethereum Layer 1 (L1) address of the deployed Naffle Diamond contract.")
  .addParam("l2nafflecontractaddress", "The address of the Naffle Diamond contract deployed on the zkSync Layer 2 (L2) network.")
  .addParam("nftcontractaddress", "The Ethereum contract address of the specific Non-Fungible Token (NFT) that is being raffled.")
  .addParam("nfttokenid", "The unique identifier (Token ID) of the specific Non-Fungible Token (NFT) that is being raffled.")
  .addParam("ticketspots", "The total number of tickets available for purchase in the Naffle event.")
  .addParam("endtimestamp", "The timestamp indicating the end time of the Naffle event.")
  .addParam("ticketpriceinwei", "The price for a single ticket in the Naffle event, specified in Wei (1 Ether = 10^18 Wei).")
  .addParam("naffletype", "The type of the Naffle event. '0' denotes a standard Naffle, and '1' denotes an unlimited Naffle.")
  .setAction(async (taskArgs, hre) => {
    const signers = await hre.ethers.getSigners()

    const l1provider = new Provider(getInfuraURL(hre.network.name));
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));

    const walletL2 = new Wallet(getPrivateKey(), l2provider, l1provider);

    const contractFactory = await hre.ethers.getContractFactory("ERC721AMock");
    const nftContractInstance = contractFactory.attach(taskArgs.nftcontractaddress);

    const isApprovedForId = await nftContractInstance.isApprovedForAll(signers[0].address, taskArgs.l1nafflecontractaddress);
    if (!isApprovedForId) {
      const approve_tx = await nftContractInstance.setApprovalForAll(taskArgs.l1nafflecontractaddress, true);
      const approve_receipt = await approve_tx.wait();
      console.log("approve_receipt: ", approve_receipt);
    }

    const l2ContractFactory = await hre.ethers.getContractFactory("L2NaffleBase");
    const l2ContractInstance = l2ContractFactory.attach(taskArgs.l2nafflecontractaddress);

    const nftId = parseInt(taskArgs.nfttokenid)
    const paidTicketSpots = parseInt(taskArgs.ticketspots)
    const ticketPriceInWei = hre.ethers.utils.parseEther("0.01")
    const endTime = taskArgs.endtimestamp
    const naffleType = parseInt(taskArgs.naffletype)

    const l2Params = {
      ethTokenAddress: taskArgs.nftcontractaddress,
      owner: signers[0].address,
      naffleId: 1,
      nftId: nftId,
      paidTicketSpots: paidTicketSpots,
      ticketPriceInWei: ticketPriceInWei,
      endTime: endTime,
      naffleType: naffleType,
      naffleTokenType: 0
    }

    console.log("preparing transaction..")
    const prepareTransaction = await l2ContractInstance.populateTransaction.createNaffle(
      l2Params
    )
    const gasPrice = await l1provider.getGasPrice();

    const gasLimit = await l2provider.estimateL1ToL2Execute({
      contractAddress: taskArgs.l2nafflecontractaddress,
      calldata: prepareTransaction.data,
      caller: utils.applyL1ToL2Alias(taskArgs.l1nafflecontractaddress)
    });

    const baseCost = await walletL2.getBaseCost({
      gasLimit: gasLimit,
      gasPrice: gasPrice,
      gasPerPubdataByte: utils.REQUIRED_L1_TO_L2_GAS_PER_PUBDATA_BYTE
    });

    console.log("BASE COST: ", baseCost)
    console.log("GAS LIMIT: ", gasLimit)

    const l1NaffleBaseFactory = await hre.ethers.getContractFactory("L1NaffleBase");
    const l1NaffleContractInstance = l1NaffleBaseFactory.attach(taskArgs.l1nafflecontractaddress);

    console.log("creating naffle..")
    const tx = await l1NaffleContractInstance.createNaffle(
      taskArgs.nftcontractaddress,
      nftId,
      paidTicketSpots,
      ticketPriceInWei,
      endTime,
      naffleType,
      {
        l2GasLimit: gasLimit,
        l2GasPerPubdataByteLimit: utils.REQUIRED_L1_TO_L2_GAS_PER_PUBDATA_LIMIT
      },
      {
        // value: baseCost,
        value: hre.ethers.utils.parseEther("0.01"),
        gasPrice: gasPrice
      }
    );
    console.log(tx)
    const receipt = await tx.wait();
    console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
  });