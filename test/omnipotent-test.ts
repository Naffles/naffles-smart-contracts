import { expect } from "chai";
import hre, {ethers} from "hardhat";
import {Contract} from "hardhat/internal/hardhat-network/stack-traces/model";
import {address} from "hardhat/internal/core/config/config-validation";
import {OmnipotentNFT} from "../typechain-types";
import { MerkleTree } from "merkletreejs";
import {BigNumber} from "ethers";
const SHA256 = require('crypto-js/sha256')

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

describe("Omnipotent Constructor", function() {
    it("Should setup roles on deploy", async function () {
        const contract = await deployContract()
        const [owner, _] = await ethers.getSigners();
        const has_role = await contract.hasRole(await contract.DEFAULT_ADMIN_ROLE(), owner.address)
        const has_withdraw_role = await contract.hasRole(await contract.WITHDRAW_ROLE(), owner.address)
        expect(has_role).to.equal(true)
        expect(has_withdraw_role).to.equal(true)
    });

    it("Should setup constructor values on deploy", async function () {
        const contract = await deployContract()
        expect(await contract.maxSupply()).to.equal(MAX_SUPPLY);
        expect(await contract.reservedTokens()).to.equal(RESERVED_TOKENS);
        expect(await contract.maxPerWallet()).to.equal(MAX_PER_WALLET);
    });

    it("Should mint reserved tokens", async function () {
        const [owner, _] = await ethers.getSigners();
        const contract = await deployContract()
        expect(await contract.totalSupply()).to.equal(RESERVED_TOKENS)
        expect(await contract.balanceOf(owner.address)).to.equal(RESERVED_TOKENS)
    })
});

async function createWhitelist(
    id: number,
    startTime: number,
    endTime: number,
    whitelisted_address: string,
    contract: OmnipotentNFT
): Promise<MerkleTree> {
    let leaves = [];
    if (whitelisted_address) {
        leaves = [whitelisted_address].map(x => SHA256(x))
    }
    const tree = new MerkleTree(leaves, SHA256);
    await contract.createWhitelist(tree.getHexRoot(), id, startTime, endTime);
    return tree
}

describe("Omnipotent create whitelist", function () {
    it("Should create whitelist", async function () {
        const startTime = getTimeSinceEpoch() - 1000;
        const endTime = startTime - 500;
        const contract = await deployContract();
        const [owner, _] = await ethers.getSigners();
        const tree = await createWhitelist(1, startTime, endTime, owner.address, contract)
        const whitelist = await contract.whitelists(1);
        expect(whitelist["root"]).to.equal(tree.getHexRoot())
        expect(whitelist["startTime"]).to.equal(startTime)
        expect(whitelist["endTime"]).to.equal(endTime)
    });
});