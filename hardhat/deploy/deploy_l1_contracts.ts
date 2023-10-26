import {
    ERC721AMock__factory,
} from '../typechain-types';
import deployL1NaffleDiamond from "./naffle/ethereum/deploy_l1_naffle_diamond";

import { ethers } from 'hardhat';

export default async function main() {
    let foundersKeyAddress = process.env.foundersKeyAddress;
    let foundersKeyPlaceholderAddress = process.env.foundersKeyPlaceholderAddress;
    let domainName = process.env.domainName || "Naffles";

    console.log("Founders key address: ", foundersKeyAddress);
    console.log("Founders key placeholder address: ", foundersKeyPlaceholderAddress);
    console.log("Domain name: ", domainName)

    if (!foundersKeyAddress || !foundersKeyPlaceholderAddress) {
        const [deployer] = await ethers.getSigners();
        const erc721Mock = await new ERC721AMock__factory(deployer).deploy({})
        foundersKeyAddress = erc721Mock.address;
        foundersKeyPlaceholderAddress = erc721Mock.address;
        console.log("Founders key address: ", foundersKeyAddress);
        console.log("Founders key placeholder address: ", foundersKeyPlaceholderAddress);
    }

    await deployL1NaffleDiamond(foundersKeyAddress, foundersKeyPlaceholderAddress, domainName);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
