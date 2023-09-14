import { task } from "hardhat/config"

task("set-vrf-manager", "Sets the vrf manager")
    .addParam("vrfaddress", "L1 naffle diamond contract address")
    .addParam("address", "address of manager")
    .setAction(async (taskArgs, hre) => {
        const contractFactory = await hre.ethers.getContractFactory("NaffleVRF");

        const contractInstance = contractFactory.attach(taskArgs.vrfaddress);
        const tx = await contractInstance.setVRFManager(taskArgs.address);
        const receipt = await tx.wait();

        console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
    });
