import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import { Wallet, Provider} from "zksync-web3";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ethers } from "ethers";
import {createDir, createFile} from "../../utils/util";
import hre from "hardhat";

export default async function main(hre: HardhatRuntimeEnvironment, deployerPrivateKey: string) {
  try {
    const dirPath = `data`;
    const network = hre.network.name;
    createDir(`/${dirPath}/${network}`);

    const wallet = new Wallet(deployerPrivateKey);

    // Create deployer object and load the artifact of the contract we want to deploy.
    const deployer = new Deployer(hre, wallet);

    console.log('Deploying contracts with the account:', wallet.address);

    const currentGasPrice = await hre.ethers.provider.getGasPrice();
    const increasedGasPrice = currentGasPrice.mul(2);

    console.log('Deploying L2PaidTicketDiamond..');
    const l2PaidTicketDiamondArtifact = await deployer.loadArtifact("L2PaidTicketDiamond");
    const l2PaidTicketDiamondImpl = await deployer.deploy(l2PaidTicketDiamondArtifact, [wallet.address], {
      gasPrice: increasedGasPrice
    })
    console.log(`Successfully deployed L2PaidTicketDiamond at ${l2PaidTicketDiamondImpl.address}`);

    console.log('Deploying L2PaidTicketDiamond facets..')
    const l2PaidTicketBaseArtifact = await deployer.loadArtifact("L2PaidTicketBase");
    const l2PaidTicketBaseImpl = await deployer.deploy(l2PaidTicketBaseArtifact, [], {
      gasPrice: increasedGasPrice
    })
    console.log(`Successfully deployed L2PaidTicketBase at ${l2PaidTicketBaseImpl.address}`);

    const l2PaidTicketAdminArtifact = await deployer.loadArtifact("L2PaidTicketAdmin");
    const l2PaidTicketAdminImpl = await deployer.deploy(l2PaidTicketAdminArtifact, [], {
      gasPrice: increasedGasPrice
    })
    console.log(`Successfully deployed L2PaidTicketAdmin at ${l2PaidTicketAdminImpl.address}`);

    const l2PaidTicketViewArtifact = await deployer.loadArtifact("L2PaidTicketView");
    const l2PaidTicketViewImpl = await deployer.deploy(l2PaidTicketViewArtifact, [], {
      gasPrice: increasedGasPrice
    })
    console.log(`Successfully deployed L2PaidTicketView at ${l2PaidTicketViewImpl.address}`);

    const diamondSelectors= [
      l2PaidTicketDiamondImpl
    ].map((facet) => {
      return Object.keys(facet.interface.functions).map((fn) => facet.interface.getSighash(fn));
    })[0];

    const selectors = new Set();

    const l2PaidTicketDiamondCuts = [
      l2PaidTicketBaseImpl,
      l2PaidTicketAdminImpl,
      l2PaidTicketViewImpl,
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

    console.log('l2PaidTicketDiamondCuts', l2PaidTicketDiamondCuts)

    const l2PaidTicketDiamondCutTx = await l2PaidTicketDiamondImpl
      .diamondCut(l2PaidTicketDiamondCuts, ethers.constants.AddressZero, "0x", {});
    await l2PaidTicketDiamondCutTx.wait();
    console.log(`Successfully cut facets into diamond at ${l2PaidTicketDiamondImpl.address}`);

    const l2PaidTicketDiamondAddresses = {
      l2PaidTicketDiamond: l2PaidTicketDiamondImpl.address,
      l2PaidTicketBase: l2PaidTicketBaseImpl.address,
      l2PaidTicketAdmin: l2PaidTicketAdminImpl.address,
      l2PaidTicketView: l2PaidTicketViewImpl.address,
    }

    createFile(
        `${dirPath}/${network}/L2PaidTicketDiamondAddresses.json`,
        JSON.stringify(l2PaidTicketDiamondAddresses, null, 2)
    );

    console.log('L2PaidTicketDiamond addresses:', l2PaidTicketDiamondAddresses);

    console.log("waiting for 30 seconds for the diamond to be indexed on etherscan");
    await new Promise(resolve => setTimeout(resolve, 30000));

    console.log("verifying L2PaidTicketDiamond on etherscan");
    await hre.run("verify:verify", {
      address: l2PaidTicketDiamondImpl.address,
      constructorArguments: [wallet.address],
    });

    console.log("verifying L2PaidTicketBase on etherscan");
    await hre.run("verify:verify", {
      address: l2PaidTicketBaseImpl.address,
      constructorArguments: [],
    });

    console.log("verifying L2PaidTicketAdmin on etherscan");
    await hre.run("verify:verify", {
      address: l2PaidTicketAdminImpl.address,
      constructorArguments: [],
    });

    console.log("verifying L2PaidTicketView on etherscan");
    await hre.run("verify:verify", {
      address: l2PaidTicketViewImpl.address,
      constructorArguments: [],
    });

    return l2PaidTicketDiamondAddresses;
  } catch (error) {
    console.log(error);
    process.exit(1)
  }
}
