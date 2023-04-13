import deployL2PaidTicketDiamond from "./tokens/tickets/deploy_l2_paid_ticket_diamond";
import deployL2OpenEntryTicketDiamond from "./tokens/tickets/deploy_l2_open_entry_ticket_diamond";
import deployL2NaffleDiamond from "./naffle/zksync/deploy_l2_naffle_diamond";

import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ethers } from 'hardhat';
import {Wallet} from "zksync-web3";
import {Deployer} from "@matterlabs/hardhat-zksync-deploy";

export default async function (
    hre: HardhatRuntimeEnvironment
) {
    const l1_naffle_contract_address= process.env.l1NaffleAddress;
    const deployerPrivateKey = process.env.deployerPrivateKey;
    const l2PaidTicketDiamondAddresses = await deployL2PaidTicketDiamond(hre, deployerPrivateKey);
    const l2OpenEntryTicketDiamondAddresses = await deployL2OpenEntryTicketDiamond(hre, deployerPrivateKey);
    const l2NaffleDiamondAddresses = await deployL2NaffleDiamond(
        hre,
        deployerPrivateKey,
        l1_naffle_contract_address,
        l2PaidTicketDiamondAddresses["l2PaidTicketDiamond"],
        l2OpenEntryTicketDiamondAddresses["l2OpenEntryTicketDiamond"]
    );

    const wallet = new Wallet(deployerPrivateKey);
    const deployer = new Deployer(hre, wallet);
    console.log("Setting L2Naffle contract address in L2PaidTicketDiamond and L2OpenEntryTicketDiamond...");
    const l2PaidTicketAdmin = await ethers.getContractAt("L2PaidTicketAdmin", l2PaidTicketDiamondAddresses["l2PaidTicketDiamond"]);
    const tx = await l2PaidTicketAdmin.connect(deployer.zkWallet).setL2NaffleContractAddress(wallet.address)
    await tx.wait();

    const l2OpenEntryTicketAdmin = await ethers.getContractAt("L2OpenEntryTicketAdmin", l2OpenEntryTicketDiamondAddresses["l2OpenEntryTicketDiamond"]);
    const tx2 = await l2OpenEntryTicketAdmin.connect(deployer.zkWallet).setL2NaffleContractAddress(l2NaffleDiamondAddresses["l2NaffleDiamond"]);
    await tx2.wait();
    console.log("L2Naffle address set to " + l2NaffleDiamondAddresses["l2NaffleDiamond"])
}