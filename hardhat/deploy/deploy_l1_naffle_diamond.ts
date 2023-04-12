import hre from 'hardhat';
import { ethers } from 'hardhat';
import {
  L1NaffleDiamond__factory,
  L1NaffleBase__factory,
  L1NaffleAdmin__factory,
  L1NaffleView__factory
} from '../typechain-types';

import { createDir, createFile} from './utils/util';

const MINIMUM_NAFFLE_DURATION = 60 * 60 * 24; // 1 day
const MINIMUM_PAID_TICKET_SPOTS = 10;
const MINIMUM_TICKET_PRICE_IN_WEI = ethers.utils.parseEther('0.001');
const FOUNDERS_KEY_CONTRACT_ADDRESS = ethers.constants.AddressZero;
const FOUNDERS_KEY_PLACEHOLDER_ADDRESS = ethers.constants.AddressZero;

const GAS_PRICE = ethers.utils.parseUnits('20', 'gwei');
const GAS_LIMIT = 4000000;

async function deployFacet(Factory, deployer) {
  const instance = await new Factory(deployer).deploy({ gasPrice: GAS_PRICE, gasLimit: GAS_LIMIT });
  return instance;
}

async function main() {
  try {
    const [deployer] = await ethers.getSigners();

    const dirPath = `data`;
    const network = hre.network.name;
    createDir(`/${dirPath}/${network}`);

    console.log('Deploying contracts with the account:', deployer.address);

    console.log('Deploying L1NaffleDiamond..');
    const l1NaffleDiamondImpl = await new L1NaffleDiamond__factory(deployer).deploy(
      deployer.address,
      MINIMUM_NAFFLE_DURATION,
      MINIMUM_PAID_TICKET_SPOTS,
      MINIMUM_TICKET_PRICE_IN_WEI,
      FOUNDERS_KEY_CONTRACT_ADDRESS,
      FOUNDERS_KEY_PLACEHOLDER_ADDRESS,
      {
        gasPrice: GAS_PRICE,
        gasLimit: GAS_LIMIT,
      }
    );
    console.log(`Successfully deployed L1NaffleDiamond at ${l1NaffleDiamondImpl.address}`);

    console.log('Deploying Diamond facets..');
    console.log('Deploying L1NaffleBase facet..');
    const l1NaffleBaseImpl = await deployFacet(L1NaffleBase__factory, deployer);
    console.log(`Successfully deployed L1NaffleBase facet at ${l1NaffleBaseImpl.address}`);

    console.log('Deploying L1NaffleAdmin facet..');
    const l1NaffleAdminImpl = await deployFacet(L1NaffleAdmin__factory, deployer);
    console.log(`Successfully deployed L1NaffleAdmin facet at ${l1NaffleAdminImpl.address}`);

    console.log('Deploying L1NaffleView facet..');
    const l1NaffleViewImpl = await deployFacet(L1NaffleView__factory, deployer);
    console.log(`Successfully deployed L1NaffleView facet at ${l1NaffleViewImpl.address}`);

    console.log('Getting selectors for diamond..');

    const l1NaffleDiamondOriginalCuts = Object.keys(l1NaffleDiamondImpl.interface.functions).map((fn) =>
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
      .diamondCut(l1NaffleDiamondCuts, ethers.constants.AddressZero, '0x', {
        gasPrice: GAS_PRICE,
        gasLimit: GAS_LIMIT,
    });

    await l1NaffleDiamondCutTx.wait();
    console.log('Successfully cut L1Naffle facets into L1NaffleDiamond');

    const l1NaffleDiamondAddresses = {
      L1NaffleDiamond: l1NaffleDiamondImpl.address,
      L1NaffleBase: l1NaffleBaseImpl.address,
      L1NaffleAdmin: l1NaffleAdminImpl.address,
      L1NaffleView: l1NaffleViewImpl.address,
    };

    createFile(
      `${dirPath}/${network}/L1NaffleDiamondAddresses.json`,
      JSON.stringify(l1NaffleDiamondAddresses, null, 2)
    );

    console.log('L1NaffleDiamondAddresses: ', l1NaffleDiamondAddresses);
  } catch (error) {
    console.error('Error in main function:', error);
    process.exit(1);
  }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
});
