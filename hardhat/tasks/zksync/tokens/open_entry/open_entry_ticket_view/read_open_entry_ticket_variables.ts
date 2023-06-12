import { task } from "hardhat/config"
import {Provider, Wallet} from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../../util";

task("read-open-entry-ticket-variables", "Sets the founders key on the naffle contract")
  .addParam("openentryticketcontractaddress", "L2 open entry ticket diamond contract address")
  .setAction(async (taskArgs, hre) => {
    const contractFactory = await hre.ethers.getContractFactory("L2OpenEntryTicketView");
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const walletL2 = new Wallet(getPrivateKey(), l2provider);

    const contractInstance = contractFactory.attach(taskArgs.openentryticketcontractaddress);
    
    console.log("get l2 naffle contract address : ", await contractInstance.connect(walletL2).getL2NaffleContractAddress());
  });
