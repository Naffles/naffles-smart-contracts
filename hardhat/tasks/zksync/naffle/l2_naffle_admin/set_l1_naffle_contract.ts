import {task} from "hardhat/config";
import {Provider, Wallet} from "zksync-web3";

task("set-l1-naffle-contract", "set l1 naffle contract address on l2 naffle contract")
  .addParam("l2nafflecontractaddress", "L2 naffle diamond contract address")
  .addParam("l1nafflecontractaddress", "L1 naffle diamond contract address")
  .setAction(async (taskArgs, hre) => {
    const WALLET_PRIV_KEY = process.env.PRIVATE_KEY || "";

    if (!WALLET_PRIV_KEY) {
      throw new Error("Wallet private key is not configured in env file");
    }

    const INFURA_API_KEY = process.env.INFURA_API_KEY || "";
    const L2_RPC_ENDPOINT = "https://testnet.era.zksync.dev"
    const l2provider = new Provider(L2_RPC_ENDPOINT);

    const walletL2 = new Wallet(WALLET_PRIV_KEY, l2provider);

    const contractFactory = await hre.ethers.getContractFactory("L2NaffleAdmin");
    const contractInstance = contractFactory.attach(taskArgs.l2nafflecontractaddress);

    const tx = await contractInstance.connect(walletL2).setL1NaffleContractAddress(taskArgs.l1nafflecontractaddress);
    console.log("setL1NaffleContractAddress tx: ", tx);
    await tx.wait();
    console.log("l1 contract address set to ", taskArgs.l1nafflecontractaddress);
  });