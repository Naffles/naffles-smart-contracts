import { ethers } from 'hardhat';

export default async function main() {
    const l1NaffleAddress = process.env.l1NaffleAddress;
    const l2NaffleAddress = process.env.l2NaffleAddress;

    console.log("Updating L1NaffleDiamond with L2NaffleDiamond address");
    const [deployer] = await ethers.getSigners();
    const l1NaffleDiamond = await ethers.getContractFactory("L1NaffleAdmin");
    const contract = await l1NaffleDiamond.attach(l1NaffleAddress);
    await contract.connect(deployer).setZkSyncNaffleContractAddress(l2NaffleAddress);

    console.log("L2NaffleDiamond address set to: ", l2NaffleAddress)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
