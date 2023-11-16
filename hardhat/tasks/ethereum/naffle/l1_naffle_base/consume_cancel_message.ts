import { task } from "hardhat/config"
import { Wallet, Provider, utils } from "zksync-web3";
import {getInfuraURL, getPrivateKey, getRPCEndpoint} from "../../../util";

task("consume-cancel-message", "Creates a naffle on the L1 contract")
  .addParam("l1nafflecontractaddress", "The Ethereum Layer 1 (L1) address of the deployed Naffle Diamond contract.")
  .addParam("l2nafflecontractaddress", "The zkSync Layer 2 (L2) address of the deployed Naffle Diamond contract.")
  .addParam("l2transactionhash", "The hash of the l2 transaction where the message was sent.")
  .addParam("naffleid", "The id of the naffle of which to get the cancel message")
  .addParam("l2messagehash", "The hash of the l2 message of the cancelled naffle.")
  .setAction(async (taskArgs, hre) => {
    const l1provider = new Provider(getInfuraURL(hre.network.name));
    const l2provider = new Provider(getRPCEndpoint(hre.network.name));

    const l1ContractFactory = await hre.ethers.getContractFactory("L1NaffleBase");
    const l1ContractInstance = l1ContractFactory.attach(taskArgs.l1nafflecontractaddress);

    let providedHash = taskArgs.l2messagehash
    console.log("providedHash: ", providedHash)

    let message = hre.ethers.utils.defaultAbiCoder.encode(
      ["string", "uint256"],
      ["cancel", taskArgs.naffleid]
    );


    console.log("PROVIDED MESSAGE: ", message)
    console.log("MESSGE", message)

    const { l1BatchNumber, l1BatchTxIndex , blockNumber } = await l2provider.getTransactionReceipt(taskArgs.l2transactionhash);
    console.log("blockNumber: ", blockNumber)

    console.log("getting proof..")
    const proof = await l2provider.getMessageProof(blockNumber, taskArgs.l2nafflecontractaddress, providedHash)
    console.log("proof: ", proof)

    const zkAddress = await l2provider.getMainContractAddress();
    console.log("zkAddress: ", zkAddress)

    const mailboxL1Contract = new hre.ethers.Contract(zkAddress, utils.ZKSYNC_MAIN_ABI, l1provider);

    const messageInfo = {
      txNumberInBlock: l1BatchTxIndex,
      sender: taskArgs.l2nafflecontractaddress,
      data: taskArgs.l2messagehash,
    };

    console.log("messageInfo: ", messageInfo)

    console.log(`Retrieving proof for batch ${l1BatchNumber}, transaction index ${l1BatchTxIndex} and proof id ${proof.id}`);

        
    const res = await mailboxL1Contract.proveL2MessageInclusion(
      l1BatchNumber,
      proof.id,
      messageInfo,
      proof.proof
    );

    console.log("*************")

    console.log("res: ", res);

    const singers = await hre.ethers.getSigners();
    const signer = singers[0];
    // setting proof on l1
    
    return

    const consumeWinnerTranscation = await l1ContractInstance.connect(signer).consumeCancelMessage(
      l1BatchNumber,
      proof.id,
      l1BatchTxIndex,
      providedHash,
      message,
      proof?.proof
    )
    const consumeReceipt = await consumeWinnerTranscation.wait()
    console.log("consumeReceipt: ", consumeReceipt)
  });
