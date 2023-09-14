import { task } from "hardhat/config"

task("set-chainlink-settings", "draws a winner")
    .addParam("vrfaddress", "L1 naffle diamond contract address")
    .addParam("keyhash", "keyhash")
    .addParam("subscriptionid", "subscriptionid")
    .addParam("callbackgaslimit", "callbackgaslimit")
    .addParam("requestconfirmations", "requestconfirmations")
    .setAction(async (taskArgs, hre) => {
        const contractFactory = await hre.ethers.getContractFactory("NaffleVRF");

        const contractInstance = contractFactory.attach(taskArgs.vrfaddress);
        const tx = await contractInstance.setChainlinkVRFSettings(
            taskArgs.subscriptionid,
            taskArgs.keyhash,
            taskArgs.callbackgaslimit,
            taskArgs.requestconfirmations
        );
        const receipt = await tx.wait();

        console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
    });
