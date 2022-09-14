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

    it("Should raise InvalidWhitelistTime", async function () {
        const {contract, user} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        const tree = createTree([user.address]);
        await expect(
            contract.createWhitelist(tree.getHexRoot(), 1, 1, 1, startTime, startTime - 10000)
        ).to.be.revertedWithCustomError(contract, "InvalidWhitelistTime");
    });

    it("Should raise InvalidWhitelistPhase", async function () {
        const {contract, user} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        const tree = createTree([user.address]);
        await expect(
            contract.createWhitelist(tree.getHexRoot(), 1, 1, 3, startTime, startTime + 10000)
        ).to.be.revertedWithCustomError(contract, "InvalidWhitelistPhase");
    });

    it("Should raise InvalidWhitelistAllowance omnipotent mint", async function () {
        const {contract, user} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        const tree = createTree([user.address]);
        await expect(
            contract.createWhitelist(tree.getHexRoot(), 1, 2, 1, startTime, startTime + 10000)
        ).to.be.revertedWithCustomError(contract, "InvalidWhitelistAllowance");
    });

    it("Should raise InvalidWhitelistAllowance founders mint", async function () {
        const {contract, user} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        const tree = createTree([user.address]);
        await expect(
            contract.createWhitelist(tree.getHexRoot(), 1, 6, 2, startTime, startTime + 10000)
        ).to.be.revertedWithCustomError(contract, "InvalidWhitelistAllowance");
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

describe("Founders mint", function () {
    it("Should public mint", async function () {
        const {contract, user} = await getContractAndUsers();
        await contract.connect(user).foundersMint(1, {value: ethers.utils.parseEther("0.1")});
        expect(await contract.balanceOf(user.address)).to.equal(1);
    });

    it("Should raise InsufficientFunds", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).foundersMint(1, {value: ethers.utils.parseEther("0.05")})
        ).to.revertedWithCustomError(contract, "InsufficientFunds");
        expect(await contract.balanceOf(user.address)).to.equal(0);
    });

    it("Should raise InsufficientSupplyAvailable", async function () {
        const {contract, user} = await getContractAndUsers(MAX_SUPPLY);
        await expect(
            contract.connect(user).foundersMint(1, {value: ethers.utils.parseEther("0.1")})
        ).to.be.revertedWithCustomError(contract, "InsufficientSupplyAvailable");
    })

    it("Should raise ExceedingMaxTokensPerWallet", async function () {
        const {contract, user} = await getContractAndUsers();
        await contract.connect(user).foundersMint(
            1, {value: ethers.utils.parseEther("0.1")}).then(async () => {
            await expect(
                contract.connect(user).foundersMint(5, {value: ethers.utils.parseEther("0.5")})
            ).to.be.revertedWithCustomError(contract, "ExceedingMaxTokensPerWallet");
        });
    });

    it("Should raise InsufficientSupplyAvailable", async function () {
        const {contract, user, owner} = await getContractAndUsers(1, 1);
        await contract.adminMint(owner.address, MAX_SUPPLY - 1)
        await expect(
            contract.connect(user).foundersMint(1, {value: ethers.utils.parseEther("0.1")})
        ).to.be.revertedWithCustomError(contract, "InsufficientSupplyAvailable");
    });

    it("Should raise SaleNotActive", async function () {
        const {contract, user} = await getContractAndUsers(RESERVED_TOKENS, MAX_OMNIPOTENT_SUPPLY, getTimeSinceEpoch() + 1000000)
        await expect(
            contract.connect(user).foundersMint(1, {value: ethers.utils.parseEther("0.1")})
        ).to.be.revertedWithCustomError(contract, "SaleNotActive");
    });

    it("Should have withdrawn money", async function () {
        const {contract, user} = await getContractAndUsers();
        const oldBalance = await ethers.provider.getBalance(user.address);
        await contract.connect(user).foundersMint(1, {value: ethers.utils.parseEther("0.1")});
        const newBalance = await ethers.provider.getBalance(user.address);
        const expectedBalance = oldBalance.sub(ethers.utils.parseEther("0.1"));
        // minus gas cost
        expect(newBalance).to.lt(expectedBalance);
    });

    it("Should send back money", async function () {
        const {contract, user} = await getContractAndUsers();
        const oldBalance = await ethers.provider.getBalance(user.address);
        await contract.connect(user).foundersMint(1, {value: ethers.utils.parseEther("0.2")}).then(async () => {
            const newBalance = await ethers.provider.getBalance(user.address);
            const expectedBalance = oldBalance.sub(ethers.utils.parseEther("0.1"));
            // Minus gas cost
            expect(newBalance).to.lt(expectedBalance);
        });
    });
})

describe("Omnipotent mint", function () {
    it("Should public mint", async function () {
        const {contract, user} = await getContractAndUsers();
        await contract.connect(user).omnipotentMint(1, {value: ethers.utils.parseEther("0.1")});
        expect(await contract.balanceOf(user.address)).to.equal(1);
    });

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

describe("setFoundersPublicMintStartTime", function () {
    it("Should set founders public mint start time", async function () {
        const {contract, owner} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch() + 1000;
        await contract.connect(owner).setFoundersPublicMintStartTime(startTime);
        expect(await contract.foundersPublicMintStartTime()).to.equal(startTime);
    });

    it("Should revert because of auth", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).setFoundersPublicMintStartTime(0)
        ).to.be.reverted
    });
});

describe("setOmnipotentPublicMintStartTime", function () {
    it("Should set omnipotent public mint start time", async function () {
        const {contract, owner} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch() + 1000;
        await contract.connect(owner).setOmnipotentPublicMintStartTime(startTime);
        expect(await contract.omnipotentPublicMintStartTime()).to.equal(startTime);
    });

    it("Should revert because of auth", async function () {
        const {contract, user} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch() + 1000;
        await expect(
            contract.connect(user).setOmnipotentPublicMintStartTime(startTime)
        ).to.be.reverted
    });
});

describe("setMintPrice", function () {
    it("Should set mint price", async function () {
        const {contract, owner} = await getContractAndUsers();
        const price = ethers.utils.parseEther("1");
        await contract.connect(owner).setMintPrice(price);
        expect(await contract.mintPrice()).to.equal(price);
    });

    it("Should revert because of auth", async function () {
        const {contract, user} = await getContractAndUsers();
        const price = ethers.utils.parseEther("1");
        await expect(
            contract.connect(user).setMintPrice(price)
        ).to.be.reverted
    });
});

describe("setMaxTotalSupply", function () {
    it("Should set max total supply", async function () {
        const {contract, owner} = await getContractAndUsers();
        await contract.connect(owner).setMaxTotalSupply(100);
        expect(await contract.maxTotalSupply()).to.equal(100);
    });

    it("Should revert because of auth", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).setMaxTotalSupply(100)
        ).to.be.reverted
    });
    it('Should revert with MaxTotalSupplyCannotBeLessThanAlreadyMinted', async function () {
        const {contract, owner} = await getContractAndUsers();
        await expect(contract.connect(owner).setMaxTotalSupply(
            10)
        ).to.be.revertedWithCustomError(contract, "MaxTotalSupplyCannotBeLessThanAlreadyMinted");
    });
});

describe("setMaxOmnipotentMintsPerWallet", function () {
    it("Should set max omnipotent mints per wallet", async function () {
        const {contract, owner} = await getContractAndUsers();
        await contract.connect(owner).setMaxOmnipotentMintsPerWallet(100);
        expect(await contract.maxOmnipotentMintsPerWallet()).to.equal(100);
    });

    it("Should revert because of auth", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).setMaxOmnipotentMintsPerWallet(100)
        ).to.be.reverted
    });
});

describe("setMaxFoundersMintsPerWallet", function () {
    it("Should set max founders mints per wallet", async function () {
        const {contract, owner} = await getContractAndUsers();
        await contract.connect(owner).setMaxFoundersMintsPerWallet(100);
        expect(await contract.maxFoundersMintsPerWallet()).to.equal(100);
    });

    it("Should revert because of auth", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).setMaxFoundersMintsPerWallet(100)
        ).to.be.reverted
    });
});

describe("setTokenTypeMappingForFoundersPasses", function () {
    it("Should set token type mapping", async function () {
        const {contract, owner} = await getContractAndUsers(
            2,
            2
        );
        await contract.connect(owner).adminMint(owner.address, 5);
        await contract.connect(owner).setTokenTypeMappingForFoundersPasses([2,2,3,3,4]);
        expect(await contract.tokenType(1)).to.equal(1);
        expect(await contract.tokenType(2)).to.equal(1);
        expect(await contract.tokenType(3)).to.equal(2);
        expect(await contract.tokenType(4)).to.equal(2);
        expect(await contract.tokenType(5)).to.equal(3);
        expect(await contract.tokenType(6)).to.equal(3);
        expect(await contract.tokenType(7)).to.equal(4);
    });

    it("Should revert because of auth", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).setTokenTypeMappingForFoundersPasses([1])
        ).to.be.reverted
    });
});

describe("tokenType", function () {
   it("Should return token type of omnipotent", async function () {
         const {contract, owner} = await getContractAndUsers();
         await contract.connect(owner).adminMint(owner.address, 1);
         expect(await contract.tokenType(1)).to.equal(1);
   });

   it("Should return token type of 2", async function () {
        const {contract, owner} = await getContractAndUsers(1,1);
       await contract.connect(owner).setTokenTypeMappingForFoundersPasses([2]);
        await contract.connect(owner).adminMint(owner.address, 1);
        expect(await contract.tokenType(2)).to.equal(2);
   });

   it("Should revert because of token not minted", async function () {
       const {contract, owner} = await getContractAndUsers(1);
       await expect(
           contract.connect(owner).tokenType(2)
       ).to.be.reverted
   });
});

describe("foundersWhitelistMint", function () {
    it("Should raise SaleNotActive", async function () {
        const {contract, user} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        await createWhitelist(
            1,
            2,
            2,
            startTime - 100000,
            startTime - 50000,
            [user.address],
            contract
        ).then(async (tree) => {
            const proof = tree.getHexProof(user.address);
            expect(tree.verify(proof, user.address, tree.getHexRoot()));
            await expect(
                contract.connect(user).foundersWhitelistMint(2,{whitelist_id: 1, proof: proof})
            ).to.be.revertedWithCustomError(contract, "SaleNotActive");
        });
    });

    it("Should raise SaleNotActive because of invalid ID", async function () {
        const {contract, user} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        await createWhitelist(
            1,
            2,
            2,
            startTime,
            startTime + 10000,
            [user.address],
            contract
        ).then(async (tree) => {
            const proof = tree.getHexProof(user.address);
            expect(tree.verify(proof, user.address, tree.getHexRoot()));
            await expect(
                contract.connect(user).foundersWhitelistMint(2,{whitelist_id: 2, proof: proof}, {value: ethers.utils.parseEther("0.2")})
            ).to.be.revertedWithCustomError(contract, "SaleNotActive");
        });
    });

    it("Should raise ExceedingWhitelistAllowance", async function () {
        const {contract, user} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        await createWhitelist(
            1,
            2,
            2,
            startTime,
            startTime + 50000,
            [user.address],
            contract
        ).then(async (tree) => {
            const proof = tree.getHexProof(user.address);
            expect(tree.verify(proof, user.address, tree.getHexRoot()));
            await contract.connect(user).foundersWhitelistMint(2,{whitelist_id: 1, proof: proof}, {value: ethers.utils.parseEther("0.2")})
            await expect(
                contract.connect(user).foundersWhitelistMint(1,{whitelist_id: 1, proof: proof}, {value: ethers.utils.parseEther("0.1")})
            ).to.be.revertedWithCustomError(contract, "ExceedingWhitelistAllowance");
        });
    });

    it("Should raise not whitelisted", async function () {
        const {contract, user, owner} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        await createWhitelist(
            1,
            2,
            2,
            startTime,
            startTime + 50000,
            [owner.address],
            contract
        ).then(async (tree) => {
            const proof = tree.getHexProof(user.address);
            expect(!tree.verify(proof, user.address, tree.getHexRoot()));
            await expect(
                contract.connect(user).foundersWhitelistMint(1,{whitelist_id: 1, proof: proof}, {value: ethers.utils.parseEther("0.1")})
            ).to.be.revertedWithCustomError(contract, "NotWhitelisted");
        });
    });

    it("Should raise InsufficientFunds", async function () {
        const {contract, user, owner} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        await createWhitelist(
            1,
            2,
            2,
            startTime,
            startTime + 50000,
            [user.address],
            contract
        ).then(async (tree) => {
            const proof = tree.getHexProof(user.address);
            expect(!tree.verify(proof, user.address, tree.getHexRoot()));
            await expect(
                contract.connect(user).foundersWhitelistMint(2,{whitelist_id: 1, proof: proof}, {value: ethers.utils.parseEther("0.1")})
            ).to.be.revertedWithCustomError(contract, "InsufficientFunds");
        });
    });

    it("Should mint", async function () {
        const {contract, user, owner} = await getContractAndUsers();
        const startTime = getTimeSinceEpoch();
        await createWhitelist(
            1,
            2,
            2,
            startTime,
            startTime + 50000,
            [user.address],
            contract
        ).then(async (tree) => {
            const proof = tree.getHexProof(user.address);
            expect(!tree.verify(proof, user.address, tree.getHexRoot()));
            await contract.connect(user).foundersWhitelistMint(2,{whitelist_id: 1, proof: proof}, {value: ethers.utils.parseEther("0.2")})
            expect(await contract.balanceOf(user.address)).to.equal(2);
        });
    });
});

describe("adminMint", function () {
    it("Should raise InsufficientSupplyAvailable", async function () {
        const {contract, owner} = await getContractAndUsers();
        await expect(
            contract.connect(owner).adminMint(owner.address, 10000)
        ).to.be.revertedWithCustomError(contract, "InsufficientSupplyAvailable");
    });

    it("Should mint", async function () {
        const {contract, user, owner} = await getContractAndUsers();
        await contract.connect(owner).adminMint(user.address, 200);
        expect(await contract.balanceOf(user.address)).to.equal(200);
    });

    it("Should revert when not admin", async function () {
        const {contract, user} = await getContractAndUsers();
        await expect(
            contract.connect(user).adminMint(user.address, 200)
        ).to.be.reverted
    })
});
