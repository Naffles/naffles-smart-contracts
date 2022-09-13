import {expect} from "chai";
import hre, {ethers} from "hardhat";
import {FoundersNFT} from "../typechain-types";
import {MerkleTree} from "merkletreejs";
import keccak256 from "keccak256";

const MAX_SUPPLY = 500;
const RESERVED_TOKENS = 50;
const MAX_OMNIPOTENT_SUPPLY = 300;

function getTimeSinceEpoch(): number {
    return Math.round(new Date().getTime() / 1000)
}

async function getContractAndUsers(
    reservedTokens: number = RESERVED_TOKENS,
    maxOmnipotentSupply: number = MAX_OMNIPOTENT_SUPPLY,
    publicSaleStartTime: number = getTimeSinceEpoch(),
) {
    const contract = await deployContract(
        reservedTokens,
        maxOmnipotentSupply,
        publicSaleStartTime
    );
    const [owner, user, alternative_user] = await ethers.getSigners();
    return {contract, owner, user, alternative_user};
}

async function deployContract(
    reservedTokens: number = RESERVED_TOKENS,
    maxOmnipotentSupply: number = MAX_OMNIPOTENT_SUPPLY,
    publicSaleStartTime: number = getTimeSinceEpoch(),
): Promise<FoundersNFT> {
    const contract_factory = await hre.ethers.getContractFactory("FoundersNFT");
    const [owner, _] = await ethers.getSigners();
    const price = ethers.utils.parseEther("0.1")
    return await contract_factory.deploy(
        maxOmnipotentSupply,
        MAX_SUPPLY,
        reservedTokens,
        price,
        owner.address,
        publicSaleStartTime,
        publicSaleStartTime
    );
}

async function createWhitelist(
    id: number,
    allowance: number,
    mintPhase: number,
    startTime: number,
    endTime: number,
    whitelisted_addresses: [string],
    contract: FoundersNFT
): Promise<MerkleTree> {
    const tree = createTree(whitelisted_addresses);
    await contract.createWhitelist(tree.getHexRoot(), id, allowance, mintPhase, startTime, endTime);
    return tree
}

function createTree(whitelisted_address: [string]): MerkleTree {
    let leaves: any[] = [];
    if (whitelisted_address) {
        leaves = whitelisted_address.map(x => keccak256(x));
    }
    return new MerkleTree(leaves, keccak256, {sortPairs: true});
}

describe("Omnipotent Constructor", function () {
    it("Should setup roles on deploy", async function () {
        const {contract, owner} = await getContractAndUsers();
        const has_role = await contract.hasRole(await contract.DEFAULT_ADMIN_ROLE(), owner.address)
        const has_withdraw_role = await contract.hasRole(await contract.WITHDRAW_ROLE(), owner.address)
        expect(has_role).to.equal(true)
        expect(has_withdraw_role).to.equal(true)
    });

    it("Should setup constructor values on deploy", async function () {
        const publicSaleStartTime = getTimeSinceEpoch();
        const [owner] = await ethers.getSigners();
        const contract = await deployContract(
            RESERVED_TOKENS,
            MAX_OMNIPOTENT_SUPPLY,
            publicSaleStartTime);

        expect(await contract.maxTotalSupply()).to.equal(MAX_SUPPLY);
        expect(await contract.getNumberMinted(owner.address)).to.equal(RESERVED_TOKENS);
        expect(await contract.foundersPublicMintStartTime()).to.equal(publicSaleStartTime);
        expect(await contract.omnipotentPublicMintStartTime()).to.equal(publicSaleStartTime);
        expect(await contract.mintPrice()).to.equal(ethers.utils.parseEther("0.1"));
    });

    it("Should mint reserved tokens", async function () {
        const {contract, owner} = await getContractAndUsers();
        expect(await contract.totalSupply()).to.equal(RESERVED_TOKENS);
        expect(await contract.balanceOf(owner.address)).to.equal(RESERVED_TOKENS);
    });
});

describe("adminMint", function () {
    it("Should mint tokens", async function () {
        const {contract, user} = await getContractAndUsers();
        const mint_amount = 10;
        await contract.adminMint(user.address, mint_amount);
        expect(await contract.totalSupply()).to.equal(RESERVED_TOKENS + mint_amount);
        expect(await contract.balanceOf(user.address)).to.equal(mint_amount);
    });

    it("Should revert if not admin", async function () {
        const {contract, user} = await getContractAndUsers();
        const mint_amount = 10;
        await expect(contract.connect(user).adminMint(user.address, mint_amount)).to.be.reverted;
    });

    it("Should revert if minting more than max supply", async function () {
        const {contract, owner} = await getContractAndUsers();
        const mint_amount = MAX_SUPPLY + 1;
        await expect(contract.adminMint(owner.address, mint_amount)).to.be.revertedWithCustomError(
            contract, "InsufficientSupplyAvailable"
        );
    });
})

describe("Create whitelist", function () {
    it("Should create whitelist", async function () {
        const startTime = getTimeSinceEpoch() - 1000000;
        const endTime = startTime + 1;
        const {contract, owner} = await getContractAndUsers();
        const tree = await createWhitelist(1, 3, 2, startTime, endTime, [owner.address], contract)
        const whitelist = await contract.whitelists(1);
        expect(whitelist["root"]).to.equal(tree.getHexRoot());
        expect(whitelist["startTime"]).to.equal(startTime)
        expect(whitelist["endTime"]).to.equal(endTime)
        expect(whitelist["allowance"]).to.equal(3)
        expect(whitelist["mintPhase"]).to.equal(2)
    });

    it("Should create multiple whitelists within same timeframe", async function () {
        const startTime = getTimeSinceEpoch() - 1000000;
        const endTime = startTime + 10000;
        const {contract, user, alternative_user} = await getContractAndUsers();
        const tree = await createWhitelist(1, 2, 2, startTime, endTime, [user.address], contract)
        const tree2 = await createWhitelist(
            2, 1, 2, startTime, endTime, [alternative_user.address], contract)
        const whitelist = await contract.whitelists(1);
        const whitelist2 = await contract.whitelists(2);
        expect(whitelist["root"]).to.equal(tree.getHexRoot());
        expect(whitelist["startTime"]).to.equal(startTime)
        expect(whitelist["endTime"]).to.equal(endTime)
        expect(whitelist["allowance"]).to.equal(2)
        expect(whitelist["mintPhase"]).to.equal(2)

        expect(whitelist2["root"]).to.equal(tree2.getHexRoot());
        expect(whitelist2["startTime"]).to.equal(startTime)
        expect(whitelist2["endTime"]).to.equal(endTime)
        expect(whitelist2["allowance"]).to.equal(1)
        expect(whitelist2["mintPhase"]).to.equal(2)
    });

    // it("Should raise InvalidWhitelistId", async function () {
    //     const startTime = getTimeSinceEpoch() - 1000000;
    //     const endTime = getTimeSinceEpoch() + 50000;
    //     const {contract, owner} = await getContractAndUsers();
    //     const tree = createTree([owner.address])
    //     await expect(
    //         contract.createWhitelist(tree.getHexRoot(), 6, 1, 1, startTime, endTime)
    //     ).to.revertedWithCustomError(contract, "InvalidWhitelistId")
    // });

    it("Should raise InvalidWhitelistTime invalid end time", async function () {
        const startTime = getTimeSinceEpoch() - 1000000;
        const endTime = startTime - 1000000;
        const {contract, owner} = await getContractAndUsers();
        const tree = createTree([owner.address])
        await expect(
            contract.createWhitelist(tree.getHexRoot(), 1, 1, 1, startTime, endTime)
        ).to.revertedWithCustomError(contract, "InvalidWhitelistTime")
    });

    it("Should raise InvalidWhitelistTime invalid start time", async function () {
        const startTime = getTimeSinceEpoch();
        const endTime = startTime - 1;
        const {contract, owner} = await getContractAndUsers();
        const tree = createTree([owner.address])
        await expect(
            contract.createWhitelist(tree.getHexRoot(), 1, 1, 1, startTime, endTime)
        ).to.revertedWithCustomError(contract, "InvalidWhitelistTime");
    });

    it("Should raise InvalidWhitelistTime invalid start and end date", async function () {
        const {contract, owner} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        const tree = createTree([owner.address])
        await expect(
            contract.createWhitelist(tree.getHexRoot(), 1, 1, 1, startTime, startTime)
        ).to.revertedWithCustomError(contract, "InvalidWhitelistTime");

        await expect(
            contract.createWhitelist(tree.getHexRoot(), 1, 1, 1, startTime, startTime - 100000)
        ).to.revertedWithCustomError(contract, "InvalidWhitelistTime");
    });
});

describe("Omnipotent remove whitelist", async function () {
    it("Should remove whitelist", async function () {
        const startTime = getTimeSinceEpoch() - 1000000000;
        const endTime = startTime + 500000;
        const {contract, owner} = await getContractAndUsers();
        await createWhitelist(1, 1, 2, startTime, endTime, [owner.address], contract)
        await contract.removeWhitelist(1);
        const whitelist = await contract.whitelists(1);
        expect(whitelist["root"]).to.equal("0x0000000000000000000000000000000000000000000000000000000000000000")
        expect(whitelist["startTime"]).to.equal(0)
        expect(whitelist["endTime"]).to.equal(0)
        expect(whitelist["allowance"]).to.equal(0)
        expect(whitelist["mintPhase"]).to.equal(0)
    });
});

describe("Omnipotent mint", function () {
    it("Should public mint", async function () {
        const {contract, user} = await getContractAndUsers();
        await contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")});
        expect(await contract.balanceOf(user.address)).to.equal(1);
    });

    // it("Should public mint twice", async function () {
    //     const {contract, user} = await getContractAndUsers();
    //     await contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")});
    //     expect(await contract.balanceOf(user.address)).to.equal(1);
    //     await contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")});
    //     expect(await contract.balanceOf(user.address)).to.equal(2);
    // });

    it("Should raise InsufficientFunds", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.05")})
        ).to.revertedWithCustomError(contract, "InsufficientFunds");
        expect(await contract.balanceOf(user.address)).to.equal(0);
    });

    it("Should raise InsufficientSupplyAvailable", async function () {
        const {contract, user} = await getContractAndUsers(MAX_SUPPLY);
        await expect(
            contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")})
        ).to.be.revertedWithCustomError(contract, "InsufficientSupplyAvailable");
    })

    it("Should raise ExceedingMaxTokensPerWallet", async function () {
        const {contract, user} = await getContractAndUsers();
        await contract.connect(user).omnipotentMint(
            1, {value: ethers.utils.parseEther("0.1")}).then(async () => {
            await expect(
                contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")})
            ).to.be.revertedWithCustomError(contract, "ExceedingMaxTokensPerWallet");
        });
    });

    it("Should raise InsufficientSupplyAvailable", async function () {
        const {contract, user, owner} = await getContractAndUsers(1, 2);
        await contract.connect(user).omnipotentMint(
            1, {value: ethers.utils.parseEther("0.1")}).then(async () => {
            await expect(
                contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")})
            ).to.be.revertedWithCustomError(contract, "InsufficientSupplyAvailable");
        });
    });

    it("Should raise SaleNotActive", async function () {
        const {contract, user} = await getContractAndUsers(RESERVED_TOKENS, MAX_OMNIPOTENT_SUPPLY, getTimeSinceEpoch() + 1000000)
        await expect(
            contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")})
        ).to.be.revertedWithCustomError(contract, "SaleNotActive");
    });

    async function checkSaleNotActive(tree: MerkleTree, contract: FoundersNFT, user: any) {
        const proof = tree.getHexProof(user.address);
        expect(tree.verify(proof, user.address, tree.getHexRoot()));
        const whitelist = await contract.whitelists(1);
        expect(whitelist["root"]).to.equal(tree.getHexRoot());
        await expect(
            contract.connect(user).omnipotentWhitelistMint(
                1,
                {whitelist_id: 1, proof: proof},
                {value: ethers.utils.parseEther("0.1")})
        ).to.be.revertedWithCustomError(contract, "SaleNotActive");
    }

    it("Should raise SaleNotActive", async function () {
        const {contract, user} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();

        await createWhitelist(
            1,
            1,
            1,
            startTime - 100000,
            startTime - 50000,
            [user.address],
            contract
        ).then(async (tree) => {
            await checkSaleNotActive(tree, contract, user);
        });
        expect(await contract.balanceOf(user.address)).to.equal(0);
    });

    it("Should raise SaleNotActive too early", async function () {
        const {contract, user} = await getContractAndUsers(
            RESERVED_TOKENS,
            MAX_OMNIPOTENT_SUPPLY,
            getTimeSinceEpoch() + 1000000,
        );
        const startTime = getTimeSinceEpoch();

        await createWhitelist(
            1,
            1,
            1,
            startTime + 10000,
            startTime + 20000,
            [user.address],
            contract
        ).then(async (tree) => {
            await checkSaleNotActive(tree, contract, user);
        });
        expect(await contract.balanceOf(user.address)).to.equal(0);
    });

    it("Should whitelist mint", async function () {
        const {contract, user} = await getContractAndUsers(
            RESERVED_TOKENS,
            MAX_OMNIPOTENT_SUPPLY,
            getTimeSinceEpoch() + 1000000,
        );

        const startTime = getTimeSinceEpoch();

        await createWhitelist(
            1,
            1,
            1,
            startTime,
            startTime + 100000,
            [user.address],
            contract
        ).then(async (tree) => {
            const proof = tree.getHexProof(user.address);
            expect(tree.verify(proof, user.address, tree.getHexRoot()));
            const whitelist = await contract.whitelists(1);

            expect(whitelist["root"]).to.equal(tree.getHexRoot());

            await contract.connect(user).omnipotentWhitelistMint(
                1,
                {whitelist_id: 1, proof: proof},
                {value: ethers.utils.parseEther("0.1")});
        });
        expect(await contract.balanceOf(user.address)).to.equal(1);
    });

    it("Should raise NotWhitelisted", async function () {
        const {contract, owner, user} = await getContractAndUsers(
            RESERVED_TOKENS,
            MAX_OMNIPOTENT_SUPPLY,
            getTimeSinceEpoch() + 1000000,
        );
        const startTime = getTimeSinceEpoch();

        await createWhitelist(
            1,
            1,
            1,
            startTime,
            startTime + 100000,
            [user.address],
            contract
        ).then(async (tree) => {
            const proof = tree.getHexProof(user.address);
            await expect(
                contract.connect(owner).omnipotentWhitelistMint(
                    1,
                    {whitelist_id: 1, proof: proof},
                    {value: ethers.utils.parseEther("0.1")})
            ).to.be.revertedWithCustomError(contract, "NotWhitelisted");
        });
        expect(await contract.balanceOf(user.address)).to.equal(0);
    });


    it("Exceed max allowance", async function () {
        const {contract, user} = await getContractAndUsers(
            RESERVED_TOKENS,
            MAX_OMNIPOTENT_SUPPLY,
            getTimeSinceEpoch() + 1000000
        );
        const startTime = getTimeSinceEpoch();

        await createWhitelist(
            1,
            1,
            1,
            startTime,
            startTime + 100000,
            [user.address],
            contract
        ).then(async (tree) => {
            const proof = tree.getHexProof(user.address);
            expect(tree.verify(proof, user.address, tree.getHexRoot()));
            const whitelist = await contract.whitelists(1);
            expect(whitelist["root"]).to.equal(tree.getHexRoot());

            await contract.connect(user).omnipotentWhitelistMint(
                1,
                {whitelist_id: 1, proof: proof},
                {value: ethers.utils.parseEther("0.1")}).then(async () => {
                await expect(
                    contract.connect(user).omnipotentWhitelistMint(
                        1,
                        {whitelist_id: 1, proof: proof},
                        {value: ethers.utils.parseEther("0.1")})
                ).to.be.revertedWithCustomError(contract, "ExceedingWhitelistAllowance");
            });
        });
        expect(await contract.balanceOf(user.address)).to.equal(1);
    });

    it("Should have withdrawn money", async function () {
        const {contract, user} = await getContractAndUsers();
        const oldBalance = await ethers.provider.getBalance(user.address);
        await contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")});
        const newBalance = await ethers.provider.getBalance(user.address);
        const expectedBalance = oldBalance.sub(ethers.utils.parseEther("0.1"));
        // minus gas cost
        expect(newBalance).to.lt(expectedBalance);
    });

    it("Should send back money", async function () {
        const {contract, user} = await getContractAndUsers();
        const oldBalance = await ethers.provider.getBalance(user.address);
        await contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.2")}).then(async () => {
            const newBalance = await ethers.provider.getBalance(user.address);
            const expectedBalance = oldBalance.sub(ethers.utils.parseEther("0.1"));
            // Minus gas cost
            expect(newBalance).to.lt(expectedBalance);
        });
    });
});

describe("exists", function () {
    it("Should return true", async function () {
        const {contract, user} = await getContractAndUsers();
        await contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")});
        expect(await contract.exists(RESERVED_TOKENS + 1)).to.equal(true);
    });

    it("Should return false", async function () {
        const contract = await deployContract();
        expect(await contract.exists(RESERVED_TOKENS + 1)).to.equal(false);
    });
})

describe("tokenURI", function () {
    it("Should return token URI", async function () {
        const {contract, owner} = await getContractAndUsers();
        await contract.connect(owner).setBaseURI("https://example.com/");
        expect(await contract.tokenURI(1)).to.equal("https://example.com/1.json");
    });


    it("Should return empty string", async function () {
        const contract = await deployContract();
        expect(await contract.tokenURI(1)).to.equal("");
    })

    it("Should raise URIQueryForNonexistentToken", async function () {
        const contract = await deployContract();
        await expect(contract.tokenURI(RESERVED_TOKENS + 1)).to.be.revertedWithCustomError(contract, "URIQueryForNonexistentToken");
    });
})

describe("Set base URI", function () {
    it("Should set base URI", async function () {
        const {contract, owner} = await getContractAndUsers();
        await contract.connect(owner).setBaseURI("https://example.com");
        expect(await contract.baseURI()).to.equal("https://example.com");
    });

    it("Should revert because of auth", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).setBaseURI("https://example.com")
        ).to.be.reverted
    });
});

describe("Set base Extension", function () {
    it("Should set base extension", async function () {
        const {contract, owner} = await getContractAndUsers();
        await contract.connect(owner).setBaseExtension("");
        expect(await contract.baseExtension()).to.equal("");
    });

    it("Should revert because of auth", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).setBaseExtension(".json")
        ).to.be.reverted
    });
})

describe("Withdraw", function () {
    it("Should withdraw", async function () {
        const {contract, owner, user} = await getContractAndUsers();
        const oldBalance = await ethers.provider.getBalance(owner.address);
        await contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")});
        await contract.connect(owner).withdraw();
        const newBalance = await ethers.provider.getBalance(owner.address);
        expect(newBalance).to.be.gt(oldBalance);
    });

    it("Should revert no admin", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).withdraw()
        ).to.be.reverted
    });

    it("Should allow withdraw role", async function () {
        const {contract, owner, user} = await getContractAndUsers();
        await contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")});
        await contract.connect(owner).grantRole(contract.WITHDRAW_ROLE(), user.address);
        const oldBalance = await ethers.provider.getBalance(user.address);
        await contract.connect(user).withdraw();
        const newBalance = await ethers.provider.getBalance(user.address);
        expect(newBalance).to.be.gt(oldBalance);
    })
})

describe("SupportsInterface", function () {
    it("Should return true", async function () {
        const contract = await deployContract();
        expect(await contract.supportsInterface("0x80ac58cd")).to.equal(true);
    });

    it("Should return false", async function () {
        const contract = await deployContract();
        expect(await contract.supportsInterface("0x80ac58ce")).to.equal(false);
    });
});
