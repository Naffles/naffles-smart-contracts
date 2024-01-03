import { task } from "hardhat/config"
import { Wallet, Provider, } from "zksync-web3";
import {getPrivateKey, getRPCEndpoint} from "../../../util";

task("set-open-entry-ratio", "Creates naffle on l2 as test")
  .addParam("l2nafflecontractaddress", "The address of the Naffle Diamond contract deployed on the zkSync Layer 2 (L2) network.")
  .addParam("ratio", "The ratio of the tickets")
  .setAction(async (taskArgs, hre) => {
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));
    const walletL2 = new Wallet(getPrivateKey(), l2provider);

    const contractBaseFactory = await hre.ethers.getContractFactory("L2NaffleAdmin");
    const l2ContractInstance = contractBaseFactory.attach(taskArgs.l2nafflecontractaddress);

    console.log("setting ratio..")
    const cancelNaffleTransaction = await l2ContractInstance.connect(walletL2).setOpenEntryRatio(
      parseInt(taskArgs.ratio)
    )
    await cancelNaffleTransaction.wait()
    console.log("ratio set")
  });