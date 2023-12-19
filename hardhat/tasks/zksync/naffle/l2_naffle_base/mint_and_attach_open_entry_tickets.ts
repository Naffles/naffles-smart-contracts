import { task } from "hardhat/config"
import { Wallet, Provider, } from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../util";

task("mint-and-attach-open-entry-tickets", "Creates naffle on l2 as test")
  .addParam("l2nafflecontractaddress", "The address of the Naffle Diamond contract deployed on the zkSync Layer 2 (L2) network.")
  .addParam("openentryticketcontractaddress", "L2 open entry ticket diamond contract address")
  .addParam("amount", "The quantity of tickets you wish to attach to the specified Naffle event.")
  .addParam("naffleid", "The ID of the Naffle event you wish to attach tickets to.")
  .setAction(async (taskArgs, hre) => {
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const adminWalletL2 = new Wallet(getPrivateKey(), l2provider);
    const walletL2 = new Wallet(getPrivateKey(true), l2provider);

    const contractBaseFactory = await hre.ethers.getContractFactory("L2NaffleBase");
    const l2ContractInstance = contractBaseFactory.attach(taskArgs.l2nafflecontractaddress);

    const contractViewFactory = await hre.ethers.getContractFactory("L2OpenEntryTicketbase");
    const ticketAdminInstance= contractViewFactory.attach(taskArgs.openentryticketcontractaddress);

    console.log("minting tickets..")
    const mintTicketsTranscation = await ticketAdminInstance.connect(adminWalletL2).adminMint(
      walletL2.address,
      parseInt(taskArgs.amount)
    )
    const result = await mintTicketsTranscation.wait()
    const ticketIds = []

    result.events?.forEach((event) => {
      if (event.event == "Transfer") {
       ticketIds.push(event.args[2])
      }
    });

    console.log("attaching tickets..")
    const attachTicketsTranscation = await l2ContractInstance.connect(walletL2).useOpenEntryTickets(
      ticketIds,
      parseInt(taskArgs.naffleid)
    )
    const result2 = await attachTicketsTranscation.wait()
    console.log("tickets attached")
    return
  });
