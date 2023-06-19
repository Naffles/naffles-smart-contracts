import { task } from "hardhat/config"
import { Wallet, Provider, } from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../util";
import {BigNumber} from "ethers";

task("refund-tickets", "Draws the winner for a naffle")
  .addParam("l2nafflecontractaddress", "The address of the Naffle Diamond contract deployed on the zkSync Layer 2 (L2) network.")
  .addParam("naffleid", "The unique identifier of the Naffle event for which draw the winner.")
  .addParam("openentryticketids", "")
  .addParam("paidticketids", "")
  .setAction(async (taskArgs, hre) => {
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const walletL2 = new Wallet(getPrivateKey(true), l2provider);

    const openEntryTicketIds = taskArgs.openentryticketids.split(",");
    const paidTicketIds = taskArgs.paidticketids.split(",");

    for (let i = 0; i < openEntryTicketIds.length; i++) {
      openEntryTicketIds[i] = parseInt(openEntryTicketIds[i])
    }
    for (let i = 0; i < paidTicketIds.length; i++) {
      paidTicketIds[i] = parseInt(paidTicketIds[i])
    }

    const contractBaseFactory = await hre.ethers.getContractFactory("L2NaffleBase");
    const l2ContractInstance = contractBaseFactory.attach(taskArgs.l2nafflecontractaddress);
    const contractViewFactory = await hre.ethers.getContractFactory("L2NaffleView");
    const l2ContractViewInstance = contractViewFactory.attach(taskArgs.l2nafflecontractaddress);

    console.log("Getting naffle info..")
    const naffle = await l2ContractViewInstance.connect(walletL2).getNaffleById(hre.ethers.BigNumber.from(taskArgs.naffleid))
    console.log(naffle)

    console.log("refunding tickets..")

    const refundTicketsTransaction= await l2ContractInstance.connect(walletL2).refundTicketsForNaffle(
      parseInt(taskArgs.naffleid),
      [1],
      [],
      walletL2.address,
    )

    const winnerTxReceipt = await refundTicketsTransaction.wait()
    console.log(winnerTxReceipt)
  });