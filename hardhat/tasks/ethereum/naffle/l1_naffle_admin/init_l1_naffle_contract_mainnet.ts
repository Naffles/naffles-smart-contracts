import { task } from "hardhat/config"

task("init-l1-naffle-contract-mainnet", "Sets the founders key on the naffle contract")
  .addParam("l1nafflecontractaddress", "The Ethereum Layer 1 (L1) address of the deployed Naffle contract.")
  .addParam("zksyncnafflecontractaddress", "The address of the Naffle contract deployed on the zkSync Layer 2 (L2) network.")
  .setAction(async (taskArgs, hre) => {
    const contractFactory = await hre.ethers.getContractFactory("L1NaffleAdmin");

    const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
    await (await contractInstance.setZkSyncNaffleContractAddress(taskArgs.zksyncnafflecontractaddress)).wait();
  });
