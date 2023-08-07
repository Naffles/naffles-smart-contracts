import { task } from "hardhat/config"
import { Wallet, Provider, } from "zksync-web3";

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
    const L2_RPC_ENDPOINT = "https://testnet.era.zksync.dev"
    const infura_url = "https://goerli.infura.io/v3/" + INFURA_API_KEY
    console.log("infura url: " + infura_url)

    const l1provider = new Provider(infura_url);
    const l2provider = new Provider(L2_RPC_ENDPOINT);

    const walletL2 = new Wallet(WALLET_PRIV_KEY, l2provider, l1provider);

    console.log("SETTING l1 contract to this wallet")
    const contractFactory = await hre.ethers.getContractFactory("L2NaffleAdmin");
    const l2ContractAdminInstance = contractFactory.attach(taskArgs.l2nafflecontractaddress);

    const transaction = await l2ContractAdminInstance.connect(walletL2).setL1NaffleContractAddress("0xAE4eFd482e3d94E2c6f4330C1a293c7B758814c2")
    const tx = await transaction.wait()

    const contractBaseFactory = await hre.ethers.getContractFactory("L2NaffleBase");
    const l2ContractInstance = contractBaseFactory.attach(taskArgs.l2nafflecontractaddress);

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
   const calldata = prepareTransaction.data

    const l1GasPrice = await l1provider.getGasPrice();
    console.log("l1GasPrice", l1GasPrice)

    // const l2GasLimit = await l2provider.estimateGasL1(prepareTransaction)
    // console.log("l2GasLimit", l2GasLimit)

    const l2gaslimit = 1000000

    const baseCost = await walletL2.getBaseCost({
      // L2 computation
      gasLimit: l2gaslimit,
      // L1 gas price
      gasPrice: l1GasPrice,
    });

    console.log("baseCost", baseCost)

    console.log("CAlldata", calldata)

    const createNaffleViaL1Transaction = await walletL2.requestExecute({
      contractAddress: taskArgs.l2nafflecontractaddress,
      calldata,
      l2GasLimit: l2gaslimit,
      refundRecipient: walletL2.address,
      overrides: {
        value: baseCost,
        gasPrice: l1GasPrice,
      }
    })

    console.log("creating naffle")

    const naffletx = await l2ContractInstance.connect(walletL2).createNaffle(
      l2Params
    )
    const naffleTxReceipt = await naffletx.wait()
    console.log(naffleTxReceipt)
  }
);