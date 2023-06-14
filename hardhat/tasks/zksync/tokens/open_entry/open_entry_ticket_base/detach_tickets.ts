import { task } from "hardhat/config"
import {Provider, Wallet} from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../../util";

task("detach-ticket", "detaches open entry tickets for a cancelled nafflle")
  .addParam("openentryticketcontractaddress", "open entry ticket contract address")
  .addParam("naffleid", "Id of the naffle for which you want to refund and burn")
  .addParam("ticketid", "Id of the ticket you want to refund and burn")
  .setAction(async (taskArgs, hre) => {
    const contractFactory = await hre.ethers.getContractFactory("L2OpenEntryTicketBase");
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const walletL2 = new Wallet(getPrivateKey(true), l2provider);

    const contractInstance = contractFactory.attach(taskArgs.openentryticketcontractaddress);

    console.log("Refunding and burning ticket..")
    console.log(`Refunding and burning ticket ${taskArgs.ticketid} for naffle ${taskArgs.naffleid}`)

    const refundAndBurnTicketTransaction = await contractInstance.connect(walletL2).detachFromNaffle(
      parseInt(taskArgs.naffleid),
      parseInt(taskArgs.ticketid)
    )
    await refundAndBurnTicketTransaction.wait()
    console.log("Ticket refunded and burned")
  });
