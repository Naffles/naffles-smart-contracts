import deployL2PaidTicketDiamond from "./tokens/tickets/deploy_l2_paid_ticket_diamond";
import deployL2OpenEntryTicketDiamond from "./tokens/tickets/deploy_l2_open_entry_ticket_diamond";
import deployL2NaffleDiamond from "./naffle/zksync/deploy_l2_naffle_diamond";

import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ethers } from 'hardhat';

export default async function (
    hre: HardhatRuntimeEnvironment
) {
    const L1_NAFFLE_CONRACT_ADDRESS = process.env.l1NaffleAddress;

    const deployerPrivateKey = process.env.deployerPrivateKey;
    const l2PaidTicketDiamondAddresses = await deployL2PaidTicketDiamond(hre, deployerPrivateKey);
    const l2OpenEntryTicketDiamondAddresses = await deployL2OpenEntryTicketDiamond(hre, deployerPrivateKey);
    const l2NaffleDiamondAddresses = await deployL2NaffleDiamond(
        hre,
        deployerPrivateKey,
        L1_NAFFLE_CONRACT_ADDRESS,
        l2PaidTicketDiamondAddresses["l2PaidTicketDiamond"],
        l2OpenEntryTicketDiamondAddresses["l2OpenEntryTicketDiamond"]
    );

    const [deployer] = await ethers.getSigners();
    const l1NaffleDiamond = await ethers.getContractFactory("L1NaffleAdmin");
    const contract = await l1NaffleDiamond.attach(L1_NAFFLE_CONRACT_ADDRESS);
    await contract.connect(deployer).setZkSyncNaffleContractAddress(l2NaffleDiamondAddresses["l2NaffleDiamond"]);
}