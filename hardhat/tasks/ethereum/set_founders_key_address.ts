import { task } from "hardhat/config"

task("set-founders-key-address", "Sets the founders key on the naffle contract")
    .addParam("l1nafflecontractaddress", "L1 naffle diamond contract address")
    .addParam("founderskeyaddress", "L1 Founders key address")
    .setAction(async (taskArgs, hre) => {
        const contractFactory = await hre.ethers.getContractFactory("L1NaffleAdmin");

        const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
        const tx = await contractInstance.setFoundersKeyAddress(taskArgs.founderskeyaddress);
        const receipt = await tx.wait();

        console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
    });
