import hre, {ethers} from "hardhat";
import {Contract} from "hardhat/internal/hardhat-network/stack-traces/model";

const MAX_SUPPLY = 500;
const RESERVED_TOKENS = 50;
const MAX_PER_WALLET = 2;

function getTimeSinceEpoch() {
    const now = new Date()
    const utcMilllisecondsSinceEpoch = now.getTime() + (now.getTimezoneOffset() * 60 * 1000)
    return Math.round(utcMilllisecondsSinceEpoch / 1000)
}

async function deployContract() {
    const contract_factory = await hre.ethers.getContractFactory("OmnipotentNFT");
    const [owner, _] = await ethers.getSigners();
    return await contract_factory.deploy(
        MAX_SUPPLY,
        RESERVED_TOKENS,
        MAX_PER_WALLET,
        owner.address,
        getTimeSinceEpoch()
    );
}

describe("Omnipotent", function() {
    it("Should setup roles on deploy", async function() {
        const contract = await deployContract()
    });
});