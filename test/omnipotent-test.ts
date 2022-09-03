import { expect } from "chai";
import hre, {ethers} from "hardhat";
import {OmnipotentNFT} from "../typechain-types";
import { MerkleTree } from "merkletreejs";
const SHA256 = require('crypto-js/sha256')

const MAX_SUPPLY = 500;
const RESERVED_TOKENS = 50;
const MAX_PER_WALLET = 2;

function getTimeSinceEpoch(): number {
    return Math.round(new Date().getTime() / 1000)
}

async function deployContract(reservedTokens: number = RESERVED_TOKENS, maxPerWallet: number = MAX_PER_WALLET): Promise<OmnipotentNFT> {
    const contract_factory = await hre.ethers.getContractFactory("OmnipotentNFT");
    const [owner, _] = await ethers.getSigners();
    const price = ethers.utils.parseEther("0.1")
    return await contract_factory.deploy(
        MAX_SUPPLY,
        reservedTokens,
        maxPerWallet,
        price,
        owner.address,
        getTimeSinceEpoch()
    );
}

async function createWhitelist(
    id: number,
    startTime: number,
    endTime: number,
    whitelisted_addresses: [string],
    contract: OmnipotentNFT
): Promise<MerkleTree> {
    const tree = createTree(whitelisted_addresses);
    await contract.createWhitelist(tree.getHexRoot(), id, startTime, endTime);
    return tree
}

function createTree(whitelisted_address: [string]): MerkleTree {
    let leaves = [];
    if (whitelisted_address) {
        leaves = whitelisted_address.map(x => SHA256(x))
    }
    return new MerkleTree(leaves, SHA256);
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
        const contract = await deployContract();
        expect(await contract.totalSupply()).to.equal(RESERVED_TOKENS);
        expect(await contract.balanceOf(owner.address)).to.equal(RESERVED_TOKENS);
    });
});

describe("Omnipotent create whitelist", function () {
    it("Should create whitelist", async function () {
        const startTime = getTimeSinceEpoch() - 1000000;
        const endTime = startTime + 1;
        const contract = await deployContract();
        const [owner, _] = await ethers.getSigners();
        const tree = await createWhitelist(1, startTime, endTime, [owner.address], contract)
        const whitelist = await contract.whitelists(1);
        expect(whitelist["root"]).to.equal(tree.getHexRoot());
        expect(whitelist["startTime"]).to.equal(startTime)
        expect(whitelist["endTime"]).to.equal(endTime)
    });

    it("Should raise InvalidWhitelistId", async function () {
        const startTime = getTimeSinceEpoch() - 1000000;
        const endTime = getTimeSinceEpoch() + 50000;
        const contract = await deployContract();
        const [owner, ] = await ethers.getSigners();
        const tree = createTree([owner.address])
        await expect(
            await contract.createWhitelist(tree.getHexRoot(), 3, startTime, endTime)
        ).to.revertedWithCustomError(contract, "InvalidWhitelistId");
    });

    it("Should raise InvalidWhitelistTime invalid end time", async function () {
        const startTime = getTimeSinceEpoch() - 1000000;
        const endTime = startTime - 1000000;
        const contract = await deployContract();
        const [owner, _] = await ethers.getSigners();
        const tree = createTree([owner.address])
        await expect(
            await contract.createWhitelist(tree.getHexRoot(), 1, startTime, endTime)
        ).to.revertedWithCustomError(contract, "InvalidWhitelistTime");
    });

    it("Should raise InvalidWhitelistTime invalid start time", async function () {
        const startTime = getTimeSinceEpoch();
        const endTime = startTime - 1;
        const contract = await deployContract();
        const [owner, _] = await ethers.getSigners();
        const tree = createTree([owner.address])
        await expect(
            await contract.createWhitelist(tree.getHexRoot(), 1, startTime, endTime)
        ).to.revertedWithCustomError(contract, "InvalidWhitelistTime");
    });

    it("Should raise InvalidWhitelistTime invalid start and end date", async function () {
        const startTime = getTimeSinceEpoch();
        const contract = await deployContract();
        const [owner, _] = await ethers.getSigners();
        const tree = createTree([owner.address])
        await expect(
            await contract.createWhitelist(tree.getHexRoot(), 1, startTime, startTime)
        ).to.revertedWithCustomError(contract, "InvalidWhitelistTime");

        await expect(
            await contract.createWhitelist(tree.getHexRoot(), 1, startTime, startTime + 100000)
        ).to.revertedWithCustomError(contract, "InvalidWhitelistTime");
    });
});

describe("Omnipotent remove whitelist", async function () {
    it("Should remove whitelist", async function () {
        const startTime = getTimeSinceEpoch() - 1_000_000_000;
        const endTime = startTime + 500000;
        const contract = await deployContract();
        const [owner, user] = await ethers.getSigners();
        await createWhitelist(1, startTime, endTime, [owner.address], contract)
        await contract.removeWhitelist(1);
        const whitelist = await contract.whitelists(1);
        expect(whitelist["root"]).to.equal("0x0000000000000000000000000000000000000000000000000000000000000000")
        expect(whitelist["startTime"]).to.equal(0)
        expect(whitelist["endTime"]).to.equal(0)
    });
});

describe("Omnipotent mint", function () {
   it("Should public mint", async function () {
       const contract = await deployContract();
       const [_, user] = await ethers.getSigners();
       await contract.connect(user).mint({value: ethers.utils.parseEther("0.1")});
       expect(await contract.balanceOf(user.address)).to.equal(1);
   });

   it("Should raise InsufficientSupplyAvailable", async function() {
         const contract = await deployContract(MAX_SUPPLY);
         const [_, user] = await ethers.getSigners();
         expect(
             await contract.connect(user).mint({value: ethers.utils.parseEther("0.1")})
         ).to.be.revertedWithCustomError(contract, "InsufficientSupplyAvailable");
   })

    it("Should raise ExceedingMaxTokensPerWallet", async function() {
        const contract = await deployContract(RESERVED_TOKENS, 1);
        const [admin, user] = await ethers.getSigners();
        contract.connect(user).mint({value: ethers.utils.parseEther("0.1")})
        expect(
            await contract.mint({value: ethers.utils.parseEther("0.1")})
        ).to.be.revertedWithCustomError(contract, "InsufficientSupplyAvailable");
    })

    it("Should raise SaleNotActive", async function() {
        const contract = await deployContract();
        const [_, user] = await ethers.getSigners();
        expect(
            contract.connect(user).mint({value: ethers.utils.parseEther("0.1")})
        ).to.be.revertedWithCustomError(contract, "SaleNotActive");
    });

    it("Should whitelist mint", async function () {
        const contract = await deployContract();
        const [_, user] = await ethers.getSigners();
        const tree = await createWhitelist(
            1, getTimeSinceEpoch() - 1000000,
            getTimeSinceEpoch() - 500000,
            [user.address],
            contract
        )
        const proof = tree.getHexProof(user.address);
        await contract.connect(user).whitelistMint({whitelist_id: 1, proof: proof}, {value: ethers.utils.parseEther("0.1")});
        expect(await contract.balanceOf(user.address)).to.equal(1);
    });
});