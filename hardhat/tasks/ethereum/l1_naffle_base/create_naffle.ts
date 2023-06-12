import { task } from "hardhat/config"
import { Wallet, Provider, utils } from "zksync-web3";

const L2_RPC_ENDPOINT = "https://testnet.era.zksync.dev"

task("create-naffle", "Creates a naffle on the L1 contract")
  .addParam("l1nafflecontractaddress", "L1 naffle diamond contract address")
  .addParam("l2nafflecontractaddress", "L2 naffle diamond contract address")
  .addParam("nftcontractaddress", "contract address of nft to naffle")
  .addParam("nfttokenid", "token id of nft to naffle")
  .addParam("ticketspots", "amount")
  .addParam("endtimestamp", "end timestamp")
  .addParam("ticketpriceinwei", "ticket price in wei")
  .addParam("naffletype", "naffle type, 0 for standard, 1 for unlimited")
  .setAction(async (taskArgs, hre) => {
    const WALLET_PRIV_KEY = process.env.PRIVATE_KEY || "";

    if (!WALLET_PRIV_KEY) {
      throw new Error("Wallet private key is not configured in env file");
    }

    const signers = await hre.ethers.getSigners()

    const INFURA_API_KEY = process.env.INFURA_API_KEY || "";

    const infura_url = "https://goerli.infura.io/v3/" + INFURA_API_KEY

    const l1provider = new Provider(infura_url);
    const l2provider = new Provider(L2_RPC_ENDPOINT);

    const walletL2 = new Wallet(WALLET_PRIV_KEY, l2provider, l1provider);
    const walletL1 = new hre.ethers.Wallet(WALLET_PRIV_KEY, l1provider);

    const contractFactory = await hre.ethers.getContractFactory("ERC721AMock");
    const nftContractInstance = contractFactory.attach(taskArgs.nftcontractaddress);

    // request if we can spend the nft
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

      const contractFactory = await hre.ethers.getContractFactory("L1NaffleBase");
      const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);

      const tx = await contractInstance.connect(walletL1).createNaffle(
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
          value: baseCost,
          gasPrice: gasPrice,
        }
      );
      const receipt = await tx.wait();
      console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
    } catch (error) {
      console.error(`Error in transaction: ${error}`);
    }
  });