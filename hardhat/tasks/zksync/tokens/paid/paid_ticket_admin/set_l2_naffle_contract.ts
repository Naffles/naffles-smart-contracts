import {task} from "hardhat/config";
import {Provider, Wallet} from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../../util";

task("set-l2-naffle-contract-on-paid", "set l1 naffle contract address on l2 naffle contract")
  .addParam("l2nafflecontractaddress", "L2 naffle diamond contract address")
  .addParam("paidticketcontractaddress", "L2 paid ticket diamond contract address")
  .setAction(async (taskArgs, hre) => {
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));

    const walletL2 = new Wallet(getPrivateKey(), l2provider);

    const contractFactory = await hre.ethers.getContractFactory("L2PaidTicketAdmin");
    const contractInstance = contractFactory.attach(taskArgs.paidticketcontractaddress);

    const tx = await contractInstance.connect(walletL2).setL2NaffleContractAddress(taskArgs.l2nafflecontractaddress);
    console.log("setL2NaffleContractAddress tx: ", tx);
    await tx.wait();
    console.log("l2 naffle contract address set to", taskArgs.l2nafflecontractaddress);
  });