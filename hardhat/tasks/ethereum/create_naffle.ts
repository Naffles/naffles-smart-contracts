import { task } from "hardhat/config"

task("create-naffle", "Creates a naffle on the L1 contract")
    .addParam("l1nafflecontractaddress", "L1 naffle diamond contract address")
    .addParam("nftcontractaddress", "contract address of nft to naffle")
    .addParam("nfttokenid", "token id of nft to naffle")
    .addParam("ticketspots", "amount")
    // .addParam("endtimestamp", "end timestamp")
    .addParam("naffletype", "naffle type, 0 for standard, 1 for unlimited")
    .setAction(async (taskArgs, hre) => {
        const contractFactory = await hre.ethers.getContractFactory("L1NaffleBase");
        const nftContractFactory = await hre.ethers.getContractFactory("ERC721AMock");
        const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
        const nftContractInstance = nftContractFactory.attach(taskArgs.nftcontractaddress);

        // set approval for naffle contract to transfer nft
        const approve_tx = await nftContractInstance.setApprovalForAll(taskArgs.l1nafflecontractaddress, true);
        const approve_receipt = await approve_tx.wait();

        const next_week = Math.floor(Date.now() / 1000) + 604800
        console.log(next_week)
        try {
            const tx = await contractInstance.createNaffle(
                taskArgs.nftcontractaddress,
                taskArgs.nfttokenid,
                taskArgs.ticketspots,
                hre.ethers.utils.parseEther("0.001"),
                next_week,
                taskArgs.naffletype
            );
            const receipt = await tx.wait();
            console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
        } catch (e) {
            console.log(e)
        }
    });
