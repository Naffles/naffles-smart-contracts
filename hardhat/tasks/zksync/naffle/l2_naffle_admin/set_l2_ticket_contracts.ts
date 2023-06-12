import {task} from "hardhat/config";
import {Provider, Wallet} from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../util";

task("set-l2-ticket-contracts", "set l1 naffle contract address on l2 naffle contract")
  .addParam("l2nafflecontractaddress", "L2 naffle diamond contract address")
  .addParam("paidticketcontractaddress", "The address of the smart contract responsible for managing paid entries/tickets for Naffle events.")
  .addParam("openentryticketcontractaddress", "The address of the smart contract responsible for managing open (or free) entries/tickets for Naffle events.")
  .setAction(async (taskArgs, hre) => {
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const walletL2 = new Wallet(getPrivateKey(), l2provider);

    const contractFactory = await hre.ethers.getContractFactory("L2NaffleAdmin");
    const contractInstance = contractFactory.attach(taskArgs.l2nafflecontractaddress);

    console.log("setting paid ticket contract address to ", taskArgs.paidticketcontractaddress);
    const paidTx = await contractInstance.connect(walletL2).setPaidTicketContractAddress(taskArgs.paidticketcontractaddress);
    await paidTx.wait();

    console.log("setting open entry ticket contract address to ", taskArgs.openentryticketcontractaddress);
    const openTx = await contractInstance.connect(walletL2).setOpenEntryTicketContractAddress(taskArgs.openentryticketcontractaddress);
    await openTx.wait();

    console.log("Paid ticket contract address set to ", taskArgs.paidticketcontractaddress);
    console.log("Open entry ticket contract address set to ", taskArgs.openentryticketcontractaddress);
  });