import { task } from "hardhat/config"
import { Wallet, Provider, utils } from "zksync-web3";
import {getInfuraURL, getPrivateKey, getRPCEndpoint} from "../../../util";


task("consume-set-winner-message", "Creates a naffle on the L1 contract")
  .addParam("l1nafflecontractaddress", "The Ethereum Layer 1 (L1) address of the deployed Naffle Diamond contract.")
  .addParam("l2nafflecontractaddress", "The zkSync Layer 2 (L2) address of the deployed Naffle Diamond contract.")
  .addParam("l2transactionhash", "The hash of the l2 transaction where the winner was set.")
  .addParam("l2messagehash", "The hash of the l2 message where the winner was set.")
  .setAction(async (taskArgs, hre) => {
    const signers = await hre.ethers.getSigners()

    const l1provider = new Provider(getInfuraURL(hre.network.name));
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));

    const walletL2 = new Wallet(getPrivateKey(), l2provider, l1provider);

    const l1ContractFactory = await hre.ethers.getContractFactory("L1NaffleBase");
    const l1ContractInstance = l1ContractFactory.attach(taskArgs.l1nafflecontractaddress);

    const { l1BatchNumber, l1BatchTxIndex , blockNumber} = await l2provider.getTransactionReceipt(taskArgs.l2transactionhash);

    let providedHash = "0x" + taskArgs.l2messagehash

    console.log("getting proof..")
    const proof = await l2provider.getMessageProof(blockNumber, taskArgs.l2nafflecontractaddress, providedHash)
    console.log("proof: ", proof)

    const zkAddress = await l2provider.getMainContractAddress();

    const mailboxL1Contract = new hre.ethers.Contract(zkAddress, utils.ZKSYNC_MAIN_ABI, l1provider);

    const messageInfo = {
      txNumberInBlock: l1BatchTxIndex,
      sender: taskArgs.l2nafflecontractaddress,
      data: providedHash
    };

    console.log("proving inclusion..")

    // l1ContractInstance.consumeSetWinnerMessage(blockNumber, proof.id,

    const res = await mailboxL1Contract.proveL2MessageInclusion(
      l1BatchNumber,
      proof.id,
      messageInfo,
      proof.proof
    );

    console.log("res: ", res);
  });