import {task} from "hardhat/config";
import {Provider, Wallet} from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../util";


task("consume-admin-cancel-naffle-message", "Consumes the message hash from zksync and cancels the naffle on L1")
  .addParam("l1nafflecontractaddress", "The Ethereum Layer 1 (L1) address of the deployed Naffle contract.")
  .setAction(async (taskArgs, hre) => {
    const contractFactory = await hre.ethers.getContractFactory("L1NaffleAdmin");
    const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
  });