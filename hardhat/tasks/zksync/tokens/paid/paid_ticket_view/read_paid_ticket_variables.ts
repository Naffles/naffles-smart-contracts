import { task } from "hardhat/config"
import {Provider, Wallet} from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../../util";

task("read-paid-ticket-variables", "Sets the founders key on the naffle contract")
  .addParam("paidticketcontractaddress", "")
  .setAction(async (taskArgs, hre) => {
    const contractFactory = await hre.ethers.getContractFactory("L2PaidTicketView");
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const walletL2 = new Wallet(getPrivateKey(), l2provider);

    const contractInstance = contractFactory.attach(taskArgs.paidticketcontractaddress);
    
    console.log("get l2 naffle contract address : ", await contractInstance.connect(walletL2).getL2NaffleContractAddress());
  });
