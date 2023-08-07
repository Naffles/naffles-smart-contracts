import { task } from "hardhat/config"

task("mint-mock-nfts", "Mints a number of mock nfts")
    .addParam("nftcontractaddress", "contract address of nft")
    .addParam("receiver", "receiver of nft")
    .addParam("amount", "amount")
    .setAction(async (taskArgs, hre) => {
        const contractFactory = await hre.ethers.getContractFactory("ERC721AMock");

        const contractInstance = contractFactory.attach(taskArgs.nftcontractaddress);
        const tx = await contractInstance.mint(taskArgs.receiver, taskArgs.amount);
        const receipt = await tx.wait();

        console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
    });
