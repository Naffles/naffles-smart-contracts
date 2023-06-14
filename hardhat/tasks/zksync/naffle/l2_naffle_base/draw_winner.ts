import { task } from "hardhat/config"
import { Wallet, Provider, } from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../util";
import {BigNumber} from "ethers";

task("draw-winner", "Draws the winner for a naffle")
  .addParam("l2nafflecontractaddress", "The address of the Naffle Diamond contract deployed on the zkSync Layer 2 (L2) network.")
  .addParam("naffleid", "The unique identifier of the Naffle event for which draw the winner.")
  .setAction(async (taskArgs, hre) => {
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const walletL2 = new Wallet(getPrivateKey(), l2provider);

    const contractBaseFactory = await hre.ethers.getContractFactory("L2NaffleBase");
    const l2ContractInstance = contractBaseFactory.attach(taskArgs.l2nafflecontractaddress);

    const contractViewFactory = await hre.ethers.getContractFactory("L2NaffleView");
    const l2ContractViewInstance = contractViewFactory.attach(taskArgs.l2nafflecontractaddress);

    console.log("Getting naffle info..")
    const naffle = await l2ContractViewInstance.connect(walletL2).getNaffleById(hre.ethers.BigNumber.from(taskArgs.naffleid))
    console.log(naffle)

    console.log("drawing winner..")
    const drawWinnerTransaction= await l2ContractInstance.connect(walletL2).ownerDrawWinner(
      parseInt(taskArgs.naffleid)
    )

    const winnerTxReceipt = await drawWinnerTransaction.wait()
    console.log(winnerTxReceipt)
  });