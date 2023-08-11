import { task } from "hardhat/config"

task("init-l1-naffle-contract", "Sets the founders key on the naffle contract")
  .addParam("l1nafflecontractaddress", "The Ethereum Layer 1 (L1) address of the deployed Naffle contract.")
  .addParam("zksyncaddress", "The address of the zkSync contract on Ethereum Layer 1.")
  .addParam("zksyncnafflecontractaddress", "The address of the Naffle contract deployed on the zkSync Layer 2 (L2) network.")
  .addParam("founderskeyaddress", "The address associated with the key of the founder or administrator of the Naffle system.")
  .addParam("founderskeyplaceholderaddress", "A placeholder address used for testing or as a default in case the founder's key address is not specified.")
  .addParam("minimumnaffleduration", "The minimum duration of a Naffle event, specified in seconds.")
  .addParam("minimumpaidticketspots", "The minimum number of paid ticket spots that should be available in a Naffle event.")
  .addParam("minimumticketpriceinwei", "The minimum price for a ticket in a Naffle event, specified in Wei (1 Ether = 10^18 Wei).")
  .addParam("nafflevrfaddress", "The address of the VRF contract used to generate random numbers for Naffle events.")
  .setAction(async (taskArgs, hre) => {
    const contractFactory = await hre.ethers.getContractFactory("L1NaffleAdmin");

    const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
    console.log("setting duration")
    await (await contractInstance.setMinimumNaffleDuration(taskArgs.minimumnaffleduration)).wait();
    console.log("setting spots")
    await (await contractInstance.setMinimumPaidTicketSpots(taskArgs.minimumpaidticketspots)).wait();
    console.log("setting price")
    await (await contractInstance.setMinimumPaidTicketPriceInWei(taskArgs.minimumticketpriceinwei)).wait();
    console.log("setting naffle addresses")
    await (await contractInstance.setZkSyncNaffleContractAddress(taskArgs.zksyncnafflecontractaddress)).wait();
    console.log("setting founders addresses")
    await (await contractInstance.setFoundersKeyAddress(taskArgs.founderskeyaddress)).wait();
    console.log("setting zksync addresses")
    await (await contractInstance.setZkSyncAddress(taskArgs.zksyncaddress)).wait();
    console.log("setting founders placeholder addresses")
    await (await contractInstance.setFoundersKeyPlaceholderAddress(taskArgs.founderskeyplaceholderaddress)).wait();
    console.log("setting naffle vrf addresses")
    await (await contractInstance.setNaffleVRFAddress(taskArgs.nafflevrfaddress)).wait(); 
  });
