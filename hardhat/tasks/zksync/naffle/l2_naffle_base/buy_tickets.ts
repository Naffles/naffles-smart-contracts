import { task } from "hardhat/config"
import { Wallet, Provider, } from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../util";
import {BigNumber} from "ethers";

task("buy-tickets", "Creates naffle on l2 as test")
  .addParam("l2nafflecontractaddress", "The address of the Naffle Diamond contract deployed on the zkSync Layer 2 (L2) network.")
  .addParam("naffleid", "The unique identifier of the Naffle event for which you want to purchase tickets.")
  .addParam("amount", "The quantity of tickets you wish to purchase for the specified Naffle event.")
  .setAction(async (taskArgs, hre) => {
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const walletL2 = new Wallet(getPrivateKey(true), l2provider);

    const contractBaseFactory = await hre.ethers.getContractFactory("L2NaffleBase");
    const l2ContractInstance = contractBaseFactory.attach(taskArgs.l2nafflecontractaddress);

    const contractViewFactory = await hre.ethers.getContractFactory("L2NaffleView");
    const l2ContractViewInstance = contractViewFactory.attach(taskArgs.l2nafflecontractaddress);

    console.log("Getting naffle info..")
    const naffle = await l2ContractViewInstance.connect(walletL2).getNaffleById(hre.ethers.BigNumber.from(taskArgs.naffleid))
    console.log(naffle)
    const ticketPrice = naffle.ticketPriceInWei
    const ticketAmount = parseInt(taskArgs.amount)
    const value: BigNumber = ticketPrice.mul(ticketAmount)

    console.log("Buying tickets..")
    const buyTicketTranscation = await l2ContractInstance.connect(walletL2).buyTickets(
      ticketAmount,
      taskArgs.naffleid,
      {
        value: value,
      }
    )

    const naffleTxReceipt = await buyTicketTranscation.wait()
    console.log(naffleTxReceipt)
  }
);