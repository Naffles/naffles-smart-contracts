import { task } from "hardhat/config"

task("read-l1-naffle-variables", "Sets the founders key on the naffle contract")
  .addParam("l1nafflecontractaddress", "")
  .setAction(async (taskArgs, hre) => {
    const contractFactory = await hre.ethers.getContractFactory("L1NaffleView");

    const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
    
    
    console.log("minimum naffle duraion: ", await contractInstance.getMinimumNaffleDuration());
    console.log("minimum paid ticket spots: ",  await contractInstance.getMinimumPaidTicketSpots());
    console.log("minimum piad ticket price in wei: ",  await contractInstance.getMinimumPaidTicketPriceInWei());
    console.log("l2 naffle contract address: ",  await contractInstance.getZkSyncNaffleContractAddress());
    console.log("founders key address: ",  await contractInstance.getFoundersKeyAddress());
    console.log("zksync address: ",  await contractInstance.getZkSyncAddress());
    console.log("founders key placeholder address: ",  await contractInstance.getFoundersKeyPlaceholderAddress());
  });
