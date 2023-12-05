import hre, {ethers} from 'hardhat';
import {
  L1NaffleAdmin__factory,
  L1NaffleBase__factory,
  L1NaffleDiamond__factory,
  L1NaffleView__factory
} from '../../../typechain-types';

import {createDir, createFile} from '../../utils/util';

const MINIMUM_NAFFLE_DURATION = 60 * 60 * 24; // 1 day
const MINIMUM_PAID_TICKET_SPOTS = 10;

async function deployFacet(Factory, deployer, gasprice) {
  const contract = await new Factory(deployer).deploy({}, {gasPrice: gasprice});
  await contract.deployed();  // Wait for the deployment to be completed
  return contract;
}

export default async function main(foundersKeyAddress: string, foundersKeyPlaceholderAddress: string, domainName: string) {
  const [deployer] = await ethers.getSigners();

  const dirPath = `data`;
  const network = hre.network.name;
  createDir(`/${dirPath}/${network}`);

  let zkSyncContract;
  if (network === 'goerli') {
    zkSyncContract = "0x1908e2BF4a88F91E4eF0DC72f02b8Ea36BEa2319"
  } else {
    zkSyncContract = "0x32400084c286cf3e17e7b677ea9583e60a000324"
  }

  const currentGasPrice = await hre.ethers.provider.getGasPrice();
  const increasedGasPrice = currentGasPrice.mul(2);

  console.log('Deploying contracts with the account:', deployer.address);

  console.log('Deploying L1NaffleDiamond..');
  const l1NaffleDiamondImpl = await new L1NaffleDiamond__factory(deployer).deploy(
    deployer.address,
    MINIMUM_NAFFLE_DURATION,
    MINIMUM_PAID_TICKET_SPOTS,
    zkSyncContract,
    foundersKeyAddress,
    foundersKeyPlaceholderAddress,
    domainName,
    {
      gasPrice: increasedGasPrice
    }
  );

  console.log(`Successfully deployed L1NaffleDiamond at ${l1NaffleDiamondImpl.address}`);

  console.log('Deploying Diamond facets..');
  console.log('Deploying L1NaffleBase facet..');
  const l1NaffleBaseImpl = await deployFacet(L1NaffleBase__factory, deployer, increasedGasPrice);
  console.log(`Successfully deployed L1NaffleBase facet at ${l1NaffleBaseImpl.address}`);

  console.log('Deploying L1NaffleAdmin facet..');
  const l1NaffleAdminImpl = await deployFacet(L1NaffleAdmin__factory, deployer, increasedGasPrice);
  console.log(`Successfully deployed L1NaffleAdmin facet at ${l1NaffleAdminImpl.address}`);

  console.log('Deploying L1NaffleView facet..');
  const l1NaffleViewImpl = await deployFacet(L1NaffleView__factory, deployer, increasedGasPrice);
  console.log(`Successfully deployed L1NaffleView facet at ${l1NaffleViewImpl.address}`);

  console.log('Getting selectors for diamond..');

  const l1NaffleDiamondOriginalCuts= Object.keys(l1NaffleDiamondImpl.interface.functions).map((fn) =>
    l1NaffleDiamondImpl.interface.getSighash(fn)
  );

  const l1NaffleDiamondCuts = [
    l1NaffleBaseImpl,
    l1NaffleViewImpl,
    l1NaffleAdminImpl,
  ].map((facet) => {
    return {
      target: facet.address,
      action: 0,
      selectors: Object.keys(facet.interface.functions)
        .filter((fn) => !l1NaffleDiamondOriginalCuts.includes(facet.interface.getSighash(fn)))
        .map((fn) => facet.interface.getSighash(fn)),
      };
  });

  console.log('Cutting facets into diamond..');

  const l1NaffleDiamondCutTx = await l1NaffleDiamondImpl
    .connect(deployer)
    .diamondCut(l1NaffleDiamondCuts, ethers.constants.AddressZero, '0x', {});

  await l1NaffleDiamondCutTx.wait();
  console.log('Successfully cut L1Naffle facets into L1NaffleDiamond');

  const l1NaffleDiamondAddresses = {
    L1NaffleDiamond: l1NaffleDiamondImpl.address,
    L1NaffleBase: l1NaffleBaseImpl.address,
    L1NaffleAdmin: l1NaffleAdminImpl.address,
    L1NaffleView: l1NaffleViewImpl.address,
    FoundersKeyAddress: foundersKeyAddress,
    FoundersKeyPlaceholderAddress: foundersKeyPlaceholderAddress,
  };

  createFile(
    `${dirPath}/${network}/L1NaffleDiamondAddresses.json`,
    JSON.stringify(l1NaffleDiamondAddresses, null, 2)
  );

  console.log('L1NaffleDiamondAddresses: ', l1NaffleDiamondAddresses);

  console.log("verifying contracts..")

  // wait a few blocks for etherscan to index the contract
  console.log("waiting 30 seconds for etherscan to index the contract..");
  await new Promise(resolve => setTimeout(resolve, 30000));

  try {
    console.log("verifying L1NaffleDiamond..");
    await hre.run('verify:verify', {
      address: l1NaffleDiamondImpl.address,
      constructorArguments: [
        deployer.address,
        MINIMUM_NAFFLE_DURATION,
        MINIMUM_PAID_TICKET_SPOTS,
        zkSyncContract,
        foundersKeyAddress,
        foundersKeyPlaceholderAddress,
        domainName,
      ],
    });
  } catch (error) {
    console.error("Failed to verify L1NaffleDiamond:", error.message);
  }

// Verify L1NaffleBase
  try {
    console.log("verifying L1NaffleBase..");
    await hre.run('verify:verify', {
      address: l1NaffleBaseImpl.address,
      constructorArguments: [],
    });
  } catch (error) {
    console.error("Failed to verify L1NaffleBase:", error.message);
  }

// Verify L1NaffleAdmin
  try {
    console.log("verifying L1NaffleAdmin..");
    await hre.run('verify:verify', {
      address: l1NaffleAdminImpl.address,
      constructorArguments: [],
    });
  } catch (error) {
    console.error("Failed to verify L1NaffleAdmin:", error.message);
  }

// Verify L1NaffleView
  try {
    console.log("verifying L1NaffleView..");
    await hre.run('verify:verify', {
      address: l1NaffleViewImpl.address,
      constructorArguments: [],
    });
  } catch (error) {
    console.error("Failed to verify L1NaffleView:", error.message);
  }
}
