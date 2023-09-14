import { task } from "hardhat/config"

task("draw-winner-vrf", "draws a winner")
    .addParam("vrfaddress", "L1 naffle diamond contract address")
    .addParam("naffleid", "naffleid")
    .setAction(async (taskArgs, hre) => {
        const contractFactory = await hre.ethers.getContractFactory("NaffleVRF");

        const contractInstance = contractFactory.attach(taskArgs.vrfaddress);
        const tx = await contractInstance.drawWinner(taskArgs.naffleid);
        const receipt = await tx.wait();

        console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
    });
