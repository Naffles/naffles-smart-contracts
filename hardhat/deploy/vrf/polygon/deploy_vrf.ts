import hre, { ethers } from 'hardhat';
import {HardhatRuntimeEnvironment} from "hardhat/types";

export default async function deployVRF(hre: HardhatRuntimeEnvironment) {
  let vrfCoordinator = process.env.vrfCoordinator;
  let subscriptionId = parseInt(process.env.subscriptionId);
  let gasLaneKeyHash = ethers.utils.formatBytes32String(process.env.gasLaneKeyHashString);
  let callbackGasLimit = parseInt(process.env.callbackGasLimit);
  let requestConfirmations = parseInt(process.env.requestConfirmations);

  // Get the deployer account
  const [deployer] = await ethers.getSigners();

// Compile and deploy the contract
  const NaffleVRF = await ethers.getContractFactory('NaffleVRF');

  console.log("4")

  console.log("Gas Lane Key Hash String:", gasLaneKeyHash);
  console.log("Subscription ID:", subscriptionId);
  console.log("Callback Gas Limit:", callbackGasLimit);
  console.log("Request Confirmations:", requestConfirmations);


  const naffleVRF = await NaffleVRF.connect(deployer).deploy(
    vrfCoordinator,
    subscriptionId,
    gasLaneKeyHash,
    callbackGasLimit,
    requestConfirmations
  );
  console.log("5")

  console.log('NaffleVRF contract deployed at:', naffleVRF.address);

  await naffleVRF.deployTransaction.wait();

  console.log("waiting 30 seconds for etherscan to index the contract..");
  await new Promise(resolve => setTimeout(resolve, 30000));


  console.log('Verifying contract on Etherscan...');
  await hre.run('verify:verify', {
    address: naffleVRF.address,
    constructorArguments: [
      vrfCoordinator,
      subscriptionId,
      gasLaneKeyHash,
      callbackGasLimit,
      requestConfirmations,
    ],
  });
  console.log('Contract verified on Etherscan');
}

deployVRF(hre)
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
