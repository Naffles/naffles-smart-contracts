import {
    ERC721AMock__factory,
} from '../../../typechain-types';
import deployL1NaffleDiamond from "./naffle/ethereum/deploy_l1_naffle_diamond";

import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ethers } from 'hardhat';

const GAS_PRICE = ethers.utils.parseUnits('20', 'gwei');
const GAS_LIMIT = 4000000;

export default async function (
    hre: HardhatRuntimeEnvironment
) {
    let foundersKeyAddress = process.env.foundersKeyAddress;
    let foundersKeyPlaceholderAddress = process.env.foundersKeyPlaceholderAddress;

    if (!foundersKeyAddress || !foundersKeyPlaceholderAddress) {
        const [deployer] = await ethers.getSigners();
        const erc721Mock = await new ERC721AMock__factory(deployer).deploy(
            {
                gasPrice: GAS_PRICE,
                gasLimit: GAS_LIMIT,
            }
        )
        foundersKeyAddress = erc721Mock.address;
        foundersKeyPlaceholderAddress = erc721Mock.address;
    }

    await deployL1NaffleDiamond(foundersKeyAddress, foundersKeyPlaceholderAddress);
}