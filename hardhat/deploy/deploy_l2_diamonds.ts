import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import { Wallet } from "zksync-web3";
import deployL1NaffleDiamond from './naffle/ethereum/deploy_l1_naffle_diamond';
import deployL2PaidTicketDiamond from "./tokens/tickets/deploy_l2_paid_ticket_diamond";
import deployL2OpenEntryTicketDiamond from "./tokens/tickets/deploy_l2_open_entry_ticket_diamond";
import deployL2NaffleDiamond from "./naffle/zksync/deploy_l2_naffle_diamond";

import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ethers } from 'hardhat';
import {createDir, createFile} from "./utils/util";

const GAS_PRICE = ethers.utils.parseUnits('20', 'gwei');
const GAS_LIMIT = 4000000;
const L1_NAFFLE_CONRACT_ADDRESS = "0x457cCf29090fe5A24c19c1bc95F492168C0EaFdb"

export default async function (
    hre: HardhatRuntimeEnvironment
) {
    const l2PaidTicketDiamondAddresses = await deployL2PaidTicketDiamond(hre);
    const l2OpenEntryTicketDiamondAddresses = await deployL2OpenEntryTicketDiamond(hre);
    const l2NaffleDiamondAddresses = await deployL2NaffleDiamond(
        hre,
        L1_NAFFLE_CONRACT_ADDRESS,
        l2PaidTicketDiamondAddresses["l2PaidTicketDiamond"],
        l2OpenEntryTicketDiamondAddresses["l2OpenEntryTicketDiamond"]
    );

    const [deployer] = await ethers.getSigners();
    const l1NaffleDiamond = await ethers.getContractFactory("L1NaffleAdmin");
    const contract = await l1NaffleDiamond.attach(L1_NAFFLE_CONRACT_ADDRESS);
    await contract.connect(deployer).setZkSyncNaffleContractAddress(l2NaffleDiamondAddresses["l2NaffleDiamond"]);
}