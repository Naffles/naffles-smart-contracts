import { task } from "hardhat/config"

task("deploy-erc721-mock", "Deploy the erc721a mock contract")
    .setAction(async (taskArgs, hre) => {
        const [deployer] = await hre.ethers.getSigners();
        const mock= await hre.ethers.getContractFactory("ERC721AMock");

        const deployed_mock = await mock.deploy(
        );

        await deployed_mock.mint(await deployer.getAddress(), 1);

        await deployed_mock.deployed();
        console.log(`deployed to ${deployed_mock.address}`);
    });

task("mint-mock_nft", "Mint a mock nft")