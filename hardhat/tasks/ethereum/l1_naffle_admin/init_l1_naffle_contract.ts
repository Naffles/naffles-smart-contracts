import { task } from "hardhat/config"

task("init-l1-naffle-contract", "Sets the founders key on the naffle contract")
    .addParam("l1nafflecontractaddress", "")
    .addParam("zksyncaddress", "")
    .addParam("zksyncnafflecontractaddress", "")
    .addParam("founderskeyaddress", "")
    .addParam("founderskeyplaceholderaddress", "")
    .addParam("minimumnaffleduration", "")
    .addParam("minimumpaidticketspots", "")
    .addParam("minimumticketpriceinwei", "")
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
    });
