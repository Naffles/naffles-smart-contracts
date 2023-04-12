import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import { utils, Wallet, Provider} from "zksync-web3";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Provider } from "zksync-web3";
import { ethers } from "ethers";
import {
  L2PaidTicketDiamond__factory,
} from '../typechain-types';

const GAS_PRICE = ethers.utils.parseUnits('20', 'gwei');
const GAS_LIMIT = 4000000;


export default async function (hre: HardhatRuntimeEnvironment) {
  const provider = Provider.getDefaultProvider();
  //   const wallet = new Wallet(process.env.PRIVATE_KEY);
  const wallet = new Wallet("0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110");

  // Create deployer object and load the artifact of the contract we want to deploy.
  const deployer = new Deployer(hre, wallet);

  console.log('Deploying contracts with the account:', wallet.address);

  console.log('Deploying L2PaidTicketDiamond..');
  const artifact = await deployer.loadArtifact("L2PaidTicketDiamond");
  const l2PaidTicketDiamond = await deployer.deploy(artifact, [wallet.address])
  console.log(`Successfully deployed L2PaidTicketDiamond at ${l2PaidTicketDiamond.address}`);
}
