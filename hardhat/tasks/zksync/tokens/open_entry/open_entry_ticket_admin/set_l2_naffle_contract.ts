import {task} from "hardhat/config";
import {Provider, Wallet} from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../../util";

task("set-l2-naffle-contract-on-open-entry", "set l1 naffle contract address on l2 naffle contract")
  .addParam("l2nafflecontractaddress", "L2 naffle diamond contract address")
  .addParam("openentryticketcontractaddress", "L2 open entry ticket diamond contract address")
  .setAction(async (taskArgs, hre) => {
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));

    const walletL2 = new Wallet(getPrivateKey(), l2provider);

    const contractFactory = await hre.ethers.getContractFactory("L2OpenEntryTicketAdmin");
    const contractInstance = contractFactory.attach(taskArgs.openentryticketcontractaddress);

    const tx = await contractInstance.connect(walletL2).setL2NaffleContractAddress(taskArgs.l2nafflecontractaddress);
    console.log("setL2NaffleContractAddress tx: ", tx);
    await tx.wait();
    console.log("l2 naffle contract address set to", taskArgs.l1nafflecontractaddress);
  });