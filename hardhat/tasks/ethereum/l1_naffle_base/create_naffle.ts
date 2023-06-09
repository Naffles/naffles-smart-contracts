import { task } from "hardhat/config"
import {type BigNumber} from "ethers";
import { Contract, Wallet, Provider, utils } from "zksync-web3";

const L2_RPC_ENDPOINT = "https://goerli-api.zksync.io/jsrpc";

task("create-naffle", "Creates a naffle on the L1 contract")
    .addParam("l1nafflecontractaddress", "L1 naffle diamond contract address")
    .addParam("l2nafflecontractaddress", "L2 naffle diamond contract address")
    .addParam("nftcontractaddress", "contract address of nft to naffle")
    .addParam("nfttokenid", "token id of nft to naffle")
    .addParam("ticketspots", "amount")
    // .addParam("endtimestamp", "end timestamp")
    .addParam("naffletype", "naffle type, 0 for standard, 1 for unlimited")
    .setAction(async (taskArgs, hre) => {
        const WALLET_PRIV_KEY = process.env.PRIVATE_KEY || "";

        if (!WALLET_PRIV_KEY) {
            throw new Error("Wallet private key is not configured in env file");
        }

        const contractFactory = await hre.ethers.getContractFactory("L1NaffleBase");
        const l2provider = new Provider(L2_RPC_ENDPOINT);
        const l2ContractFactory = await hre.ethers.getContractFactory("L2NaffleBase");
        const nftContractFactory = await hre.ethers.getContractFactory("ERC721AMock");
        const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
        const l2ContractInstance = l2ContractFactory.attach(taskArgs.l2nafflecontractaddress);
        const nftContractInstance = nftContractFactory.attach(taskArgs.nftcontractaddress);

        const wallet = new Wallet(WALLET_PRIV_KEY, l2provider, hre.ethers.provider);

        // set approval for naffle contract to transfer nft
        const approve_tx = await nftContractInstance.setApprovalForAll(taskArgs.l1nafflecontractaddress, true);
        const approve_receipt = await approve_tx.wait();

        const next_week = Math.floor(Date.now() / 1000) + 604800;
        const signers = await hre.ethers.getSigners()

        try {
            // Get the current L1 gas price
            const l1GasPrice = await hre.ethers.provider.getGasPrice();

            console.log("l1GasPrice: ", l1GasPrice.toString());

            const l2Params = {
                ethTokenAddress: taskArgs.nftcontractaddress,
                owner: signers[0].address,
                naffleId: 1,
                nftId: taskArgs.nfttokenid,
                paidTicketSpots: taskArgs.ticketspots,
                ticketPriceInWei: hre.ethers.utils.parseEther("0.001"),
                endTime: next_week,
                naffleType: taskArgs.naffleType,
                naffleTokenType: 0
            }

            const prepareTransaction = await l2ContractInstance.populateTransaction.createNaffle(
                l2Params
            )

            const l2GasLimit = await l2provider.estimateGasL1(prepareTransaction)

            console.log("l2GasLimit: ", l2GasLimit.toString());

            const baseCost = await wallet.getBaseCost({
                // L2 computation
                gasLimit: l2GasLimit,
                // L1 gas price
                gasPrice: l1GasPrice,
            });

            console.log("baseCost: ", baseCost.toString());

            // Send the transaction【13†source】
            const tx = await contractInstance.createNaffle(
                taskArgs.nftcontractaddress,
                taskArgs.nfttokenid,
                taskArgs.ticketspots,
                hre.ethers.utils.parseEther("0.001"),
                next_week,
                taskArgs.naffletype,
                {
                    l2GasLimit: l2GasLimit,
                    l2GasPerPubdataByteLimit: utils.REQUIRED_L1_TO_L2_GAS_PER_PUBDATA_LIMIT
                },
                {
                    value: baseCost.add(l1GasPrice.mul(l2GasLimit))
                }
              );

              const receipt = await tx.wait();
              console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
        } catch (error) {
          console.error(`Error in transaction: ${error}`);
        }


        // --- old code
        // const contractFactory = await hre.ethers.getContractFactory("L1NaffleBase");
        // const nftContractFactory = await hre.ethers.getContractFactory("ERC721AMock");
        // const contractInstance = contractFactory.attach(taskArgs.l1nafflecontractaddress);
        // const nftContractInstance = nftContractFactory.attach(taskArgs.nftcontractaddress);
        //
        // // set approval for naffle contract to transfer nft
        // const approve_tx = await nftContractInstance.setApprovalForAll(taskArgs.l1nafflecontractaddress, true);
        // const approve_receipt = await approve_tx.wait();
        //
        // const next_week = Math.floor(Date.now() / 1000) + 604800
        // console.log(next_week)
        // try {
        //     const tx = await contractInstance.createNaffle(
        //         taskArgs.nftcontractaddress,
        //         taskArgs.nfttokenid,
        //         taskArgs.ticketspots,
        //         hre.ethers.utils.parseEther("0.001"),
        //         next_week,
        //         taskArgs.naffletype
        //         // extra gas info in the following format
        //     //         struct L2MessageParams {
        //         //         uint256 l2GasLimit;
        //         //         uint256 l2GasPerPubdataByteLimit;
        //         //     }
        //     );
        //     const receipt = await tx.wait();
        //     console.log(`Transaction successful with hash: ${receipt.transactionHash}`);
        // } catch (e) {
        //     console.log(e)
        // }

    });
