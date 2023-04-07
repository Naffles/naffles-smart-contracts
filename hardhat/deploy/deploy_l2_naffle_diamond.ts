import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();

import { utils, Wallet } from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";

export default async function (hre: HardhatRuntimeEnvironment) {
  // Initialize the wallet.
  const wallet = new Wallet(process.env.PRIVATE_KEY);

  // Create deployer object and load the artifact of the contract we want to deploy.
  const deployer = new Deployer(hre, wallet);
  const artifact = await deployer.loadArtifact("L2NaffleDiamond");
  console.log(artifact)


  const l2NaffleDiamond = await deployer.deploy(artifact)

  // Show the contract info.
  const contractAddress = l2NaffleDiamond.address;
  console.log(`${artifact.contractName} was deployed to ${contractAddress}`);
}


