import { task } from "hardhat/config"
import {Provider, Wallet} from "zksync-web3";

task("read-l2-naffle-variables", "Sets the founders key on the naffle contract")
  .addParam("l2nafflecontractaddress", "")
  .setAction(async (taskArgs, hre) => {
    const contractFactory = await hre.ethers.getContractFactory("L2NaffleView");
    const WALLET_PRIV_KEY = process.env.PRIVATE_KEY || "";

    if (!WALLET_PRIV_KEY) {
      throw new Error("Wallet private key is not configured in env file");
    }

    const L2_RPC_ENDPOINT = "https://testnet.era.zksync.dev"

    const l2provider = new Provider(L2_RPC_ENDPOINT);
    const walletL2 = new Wallet(WALLET_PRIV_KEY, l2provider);


    console.log(hre.network.name)
    console.log(hre.network.provider)

    console.log("l2nafflecontractaddress: ", taskArgs.l2nafflecontractaddress)
    const contractInstance = contractFactory.attach(taskArgs.l2nafflecontractaddress);
    
    console.log("get platform fee: ", await contractInstance.connect(walletL2).getPlatformFee());

    console.log("get open entry ratio: ", await contractInstance.connect(walletL2).getOpenEntryRatio());
    console.log("get l1 naffle contract address ", await contractInstance.connect(walletL2).getL1NaffleContractAddress())
  });
