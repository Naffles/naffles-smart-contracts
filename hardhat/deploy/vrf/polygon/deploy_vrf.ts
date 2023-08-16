import { ethers } from 'hardhat';
import {HardhatRuntimeEnvironment} from "hardhat/types";

export default async function main(hre: HardhatRuntimeEnvironment) {
  let vrfCoordinator = process.env.vrfCoordinator;
  let subscriptionId = process.env.subscriptionId;
  let gasLaneKeyHash = ethers.utils.formatBytes32String(process.env.gasLaneKeyHashString);
  let callbackGasLimit = process.env.callbackGasLimit;
  let _requestConfirmations = process.env.requestConfirmations;

  // Get the deployer account
  const [deployer] = await ethers.getSigners();

// Compile and deploy the contract
  const NaffleVRF = await ethers.getContractFactory('NaffleVRF');
  const naffleVRF = await NaffleVRF.connect(deployer).deploy(
    vrfCoordinator,
    subscriptionId,
    gasLaneKeyHash,
    callbackGasLimit,
    _requestConfirmations
  );

  console.log('NaffleVRF contract deployed at:', naffleVRF.address);

  await naffleVRF.deployTransaction.wait();

  console.log('Verifying contract on Etherscan...');
  await hre.run('verify:verify', {
    address: naffleVRF.address,
    constructorArguments: [
      vrfCoordinator,
      subscriptionId,
      gasLaneKeyHash,
      callbackGasLimit,
      _requestConfirmations,
    ],
  });
  console.log('Contract verified on Etherscan');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });