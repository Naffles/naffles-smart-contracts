import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import { Wallet } from "zksync-web3";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ethers } from "ethers";
import {createDir, createFile} from "../../utils/util";

const GAS_PRICE = ethers.utils.parseUnits('20', 'gwei');
const GAS_LIMIT = 4000000;

const PLATFORM_FEE = 500 // 5%
const OPEN_ENTRY_RATIO = 100 // 1%
const L1_MESSENGER_CONTRACT = "0x0000000000000000000000000000000000008008"

export default async function (
    hre: HardhatRuntimeEnvironment,
    paidTicketAddress: string,
    openEntryTicketAddress: string,
    l1NaffleDiamondContract: string
) {
  try {
    const dirPath = `data`;
    const network = hre.network.name;
    createDir(`/${dirPath}/${network}`);

    //   const wallet = new Wallet(process.env.PRIVATE_KEY);
    const wallet = new Wallet("0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110");

    // Create deployer object and load the artifact of the contract we want to deploy.
    const deployer = new Deployer(hre, wallet);

    console.log('Deploying contracts with the account:', wallet.address);

    console.log('Deploying L2NaffleDiamond..');
    const l2NaffleDiamondArtifact = await deployer.loadArtifact("L2NaffleDiamond");
    const l2NaffleDiamondImpl = await deployer.deploy(l2NaffleDiamondArtifact, [
        wallet.address,
        PLATFORM_FEE,
        OPEN_ENTRY_RATIO,
        L1_MESSENGER_CONTRACT,
      l1NaffleDiamondContract,
      paidTicketAddress,
      openEntryTicketAddress,
    ])
    console.log(`Successfully deployed L2NaffleDiamond at ${l2NaffleDiamondImpl.address}`);

    console.log('Deploying L2NaffleDiamond facets..')
    const l2NaffleBaseArtifact = await deployer.loadArtifact("L2NaffleBase");
    const l2NaffleBaseImpl = await deployer.deploy(l2NaffleBaseArtifact, [])
    console.log(`Successfully deployed L2NaffleBase at ${l2NaffleBaseImpl.address}`);

    const l2NaffleAdminArtifact = await deployer.loadArtifact("L2NaffleAdmin");
    const l2NaffleAdminImpl = await deployer.deploy(l2NaffleAdminArtifact, [])
    console.log(`Successfully deployed L2NaffleAdmin at ${l2NaffleAdminImpl.address}`);

    const l2NaffleViewArtifact = await deployer.loadArtifact("L2NaffleView");
    const l2NaffleViewImpl = await deployer.deploy(l2NaffleViewArtifact, [])
    console.log(`Successfully deployed L2NaffleView at ${l2NaffleViewImpl.address}`);

    const diamondSelectors= [
      l2NaffleDiamondImpl
    ].map((facet) => {
      return Object.keys(facet.interface.functions).map((fn) => facet.interface.getSighash(fn));
    })[0];

    const selectors = new Set();

    const l2NaffleDiamondCuts = [
      l2NaffleBaseImpl,
      l2NaffleAdminImpl,
      l2NaffleViewImpl,
    ].map((facet) => {
      return {
        target: facet.address,
        action: 0,
        selectors: Object.keys(facet.interface.functions)
            .filter(
                (fn) => !selectors.has(fn) && selectors.add(fn),
            )
            .filter((fn) => !diamondSelectors.includes(facet.interface.getSighash(fn)))
            .map((fn) => facet.interface.getSighash(fn)),
      };
    });

    console.log("All selectors ", selectors)

    console.log('l2NaffleDiamondCuts', l2NaffleDiamondCuts)

    const l2NaffleDiamondCutTx = await l2NaffleDiamondImpl
        .diamondCut(l2NaffleDiamondCuts, ethers.constants.AddressZero, "0x", {
          gasPrice: GAS_PRICE,
          gasLimit: GAS_LIMIT
        });
    await l2NaffleDiamondCutTx.wait();
    console.log(`Successfully cut facets into diamond at ${l2NaffleDiamondImpl.address}`);

    const l2NaffleDiamondAddresses = {
      l2NaffleDiamond: l2NaffleDiamondImpl.address,
      l2NaffleBase: l2NaffleBaseImpl.address,
      l2NaffleAdmin: l2NaffleAdminImpl.address,
      l2NaffleView: l2NaffleViewImpl.address,
    }

    createFile(
        `${dirPath}/${network}/L2NaffleDiamondAddresses.json`,
        JSON.stringify(l2NaffleDiamondAddresses, null, 2)
    );

    console.log('L2NaffleDiamond addresses:', l2NaffleDiamondAddresses);
    return l2NaffleDiamondAddresses;
  } catch (error) {
    console.log(error);
    process.exit(1)
  }
}
