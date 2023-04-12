import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();

import { utils, Wallet, Provider} from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";


export default async function (hre: HardhatRuntimeEnvironment) {

  // Initialize the wallet.
  const provider = Provider.getDefaultProvider();
  //   const wallet = new Wallet(process.env.PRIVATE_KEY);
  const wallet = new Wallet("0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110");

  console.log("NEW WALLET", provider)
  // Create deployer object and load the artifact of the contract we want to deploy.
  const deployer = new Deployer(hre, wallet);
  const artifact = await deployer.loadArtifact("L2NaffleDiamond");

  const l2NaffleDiamond = await deployer.deploy(artifact, [wallet.address])

  // Show the contract info.
  const contractAddress = l2NaffleDiamond.address;
  console.log(`${artifact.contractName} was deployed to ${contractAddress}`);
}


