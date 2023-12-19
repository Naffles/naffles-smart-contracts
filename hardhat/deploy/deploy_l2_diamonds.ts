import deployL2PaidTicketDiamond from "./tokens/tickets/deploy_l2_paid_ticket_diamond";
import deployL2OpenEntryTicketDiamond from "./tokens/tickets/deploy_l2_open_entry_ticket_diamond";
import deployL2NaffleDiamond from "./naffle/zksync/deploy_l2_naffle_diamond";

import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ethers } from 'hardhat';
import {Wallet, utils} from "zksync-web3";
import {Deployer} from "@matterlabs/hardhat-zksync-deploy";

export default async function (
    hre: HardhatRuntimeEnvironment
) {
    const l1_naffle_contract_address= process.env.l1NaffleAddress;
    const deployerPrivateKey = process.env.deployerPrivateKey;
    const domainName = process.env.domainName || "Naffles";
    const l2PaidTicketDiamondAddresses = await deployL2PaidTicketDiamond(hre, deployerPrivateKey);
    const l2OpenEntryTicketDiamondAddresses = await deployL2OpenEntryTicketDiamond(hre, deployerPrivateKey, domainName);
    const l2NaffleDiamondAddresses = await deployL2NaffleDiamond(
        hre,
        deployerPrivateKey,
        l2PaidTicketDiamondAddresses["l2PaidTicketDiamond"],
        l2OpenEntryTicketDiamondAddresses["l2OpenEntryTicketDiamond"],
        l1_naffle_contract_address,
        domainName
    );

    const wallet = new Wallet(deployerPrivateKey);
    const deployer = new Deployer(hre, wallet);
    console.log("Setting L2Naffle contract address in L2PaidTicketDiamond and L2OpenEntryTicketDiamond...");
    const l2PaidTicketAdmin = await ethers.getContractAt("L2PaidTicketAdmin", l2PaidTicketDiamondAddresses["l2PaidTicketDiamond"]);
    const tx = await l2PaidTicketAdmin.connect(deployer.zkWallet).setL2NaffleContractAddress(l2NaffleDiamondAddresses["l2NaffleDiamond"])
    await tx.wait();

    const l2OpenEntryTicketAdmin = await ethers.getContractAt("L2OpenEntryTicketAdmin", l2OpenEntryTicketDiamondAddresses["l2OpenEntryTicketDiamond"]);
    const tx2 = await l2OpenEntryTicketAdmin.connect(deployer.zkWallet).setL2NaffleContractAddress(l2NaffleDiamondAddresses["l2NaffleDiamond"]);
    await tx2.wait();
    console.log("L2Naffle address set to " + l2NaffleDiamondAddresses["l2NaffleDiamond"])

    console.log("Setting l1 naffle diamond contract")
    const l2NaffleDiamond = await ethers.getContractAt("L2NaffleAdmin", l2NaffleDiamondAddresses["l2NaffleDiamond"]);
    const tx3 = await l2NaffleDiamond.connect(deployer.zkWallet).setL1NaffleContractAddress(utils.applyL1ToL2Alias(l1_naffle_contract_address));
    await tx3.wait();
    console.log("L1Naffle address set to " + utils.applyL1ToL2Alias(l1_naffle_contract_address));
}
