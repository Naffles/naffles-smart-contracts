import { task } from "hardhat/config"
import {Provider, Wallet} from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../util";

task("read-l2-naffle-variables", "Sets the founders key on the naffle contract")
  .addParam("l2nafflecontractaddress", "")
  .setAction(async (taskArgs, hre) => {
    const contractFactory = await hre.ethers.getContractFactory("L2NaffleView");
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const walletL2 = new Wallet(getPrivateKey(), l2provider);

    console.log("l2nafflecontractaddress: ", taskArgs.l2nafflecontractaddress)
    const contractInstance = contractFactory.attach(taskArgs.l2nafflecontractaddress);
    
    console.log("platform fee: ", await contractInstance.connect(walletL2).getPlatformFee());
    console.log("open entry ratio: ", await contractInstance.connect(walletL2).getOpenEntryRatio());
    console.log("l1 naffle contract address ", await contractInstance.connect(walletL2).getL1NaffleContractAddress())
    console.log("paid ticket contract address", await contractInstance.connect(walletL2).getPaidTicketContractAddress())
    console.log("open entry ticket contract address", await contractInstance.connect(walletL2).getOpenEntryTicketContractAddress())
  });
