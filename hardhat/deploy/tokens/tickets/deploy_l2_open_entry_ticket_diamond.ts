import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import { Wallet } from "zksync-web3";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ethers } from "ethers";
import {createDir, createFile} from "../../utils/util";

const GAS_PRICE = ethers.utils.parseUnits('20', 'gwei');
const GAS_LIMIT = 4000000;

export default async function (hre: HardhatRuntimeEnvironment) {
  try {
    const dirPath = `data`;
    const network = hre.network.name;
    createDir(`/${dirPath}/${network}`);

    //   const wallet = new Wallet(process.env.PRIVATE_KEY);
    const wallet = new Wallet("0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110");

    // Create deployer object and load the artifact of the contract we want to deploy.
    const deployer = new Deployer(hre, wallet);

    console.log('Deploying contracts with the account:', wallet.address);

    console.log('Deploying L2OpenEntryTicketDiamond..');
    const l2OpenEntryTicketDiamondArtifact = await deployer.loadArtifact("L2OpenEntryTicketDiamond");
    const l2OpenEntryTicketDiamondImpl = await deployer.deploy(l2OpenEntryTicketDiamondArtifact, [wallet.address])
    console.log(`Successfully deployed L2OpenEntryTicketDiamond at ${l2OpenEntryTicketDiamondImpl.address}`);

    console.log('Deploying L2OpenEntryTicketDiamond facets..')
    const l2OpenEntryTicketBaseArtifact = await deployer.loadArtifact("L2OpenEntryTicketBase");
    const l2OpenEntryTicketBaseImpl = await deployer.deploy(l2OpenEntryTicketBaseArtifact, [])
    console.log(`Successfully deployed L2OpenEntryTicketBase at ${l2OpenEntryTicketBaseImpl.address}`);

    const l2OpenEntryTicketAdminArtifact = await deployer.loadArtifact("L2OpenEntryTicketAdmin");
    const l2OpenEntryTicketAdminImpl = await deployer.deploy(l2OpenEntryTicketAdminArtifact, [])
    console.log(`Successfully deployed L2OpenEntryTicketAdmin at ${l2OpenEntryTicketAdminImpl.address}`);

    const l2OpenEntryTicketViewArtifact = await deployer.loadArtifact("L2OpenEntryTicketView");
    const l2OpenEntryTicketViewImpl = await deployer.deploy(l2OpenEntryTicketViewArtifact, [])
    console.log(`Successfully deployed L2OpenEntryTicketView at ${l2OpenEntryTicketViewImpl.address}`);

    const diamondSelectors= [
      l2OpenEntryTicketDiamondImpl
    ].map((facet) => {
      return Object.keys(facet.interface.functions).map((fn) => facet.interface.getSighash(fn));
    })[0];

    const selectors = new Set();

    const l2OpenEntryTicketDiamondCuts = [
      l2OpenEntryTicketBaseImpl,
      l2OpenEntryTicketAdminImpl,
      l2OpenEntryTicketViewImpl,
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

    console.log('l2OpenEntryTicketDiamondCuts', l2OpenEntryTicketDiamondCuts)

    const l2OpenEntryTicketDiamondCutTx = await l2OpenEntryTicketDiamondImpl
      .diamondCut(l2OpenEntryTicketDiamondCuts, ethers.constants.AddressZero, "0x", {
        gasPrice: GAS_PRICE,
        gasLimit: GAS_LIMIT
      });
    await l2OpenEntryTicketDiamondCutTx.wait();
    console.log(`Successfully cut facets into diamond at ${l2OpenEntryTicketDiamondImpl.address}`);

    const l2OpenEntryTicketDiamondAddresses = {
      l2OpenEntryTicketDiamond: l2OpenEntryTicketDiamondImpl.address,
      l2OpenEntryTicketBase: l2OpenEntryTicketBaseImpl.address,
      l2OpenEntryTicketAdmin: l2OpenEntryTicketAdminImpl.address,
      l2OpenEntryTicketView: l2OpenEntryTicketViewImpl.address,
    }

    createFile(
        `${dirPath}/${network}/L2OpenEntryTicketDiamondAddresses.json`,
        JSON.stringify(l2OpenEntryTicketDiamondAddresses, null, 2)
    );

    console.log('L2OpenEntryTicketDiamond addresses:', l2OpenEntryTicketDiamondAddresses);
    return l2OpenEntryTicketDiamondAddresses;
  } catch (error) {
    console.log(error);
    process.exit(1)
  }
}