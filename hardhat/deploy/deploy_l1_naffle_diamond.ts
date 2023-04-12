import hre from 'hardhat'
import { ethers } from "hardhat";

import {
  L1NaffleDiamond__factory,
  L1NaffleDiamond,
  L1NaffleBase,
  L1NaffleBase__factory,
  L1NaffleAdmin,
  L1NaffleAdmin__factory,
  L1NaffleView,
  L1NaffleView__factory,
  ERC165Base__factory,
  Ownable__factory,
  AccessControl__factory
} from '../typechain-types'

import {
  createDir,
  createFile,
  L1NaffleDiamondAddresses
} from './utils/util';

const MINIMUM_NAFFLE_DURATION = 60 * 60 * 24; // 1 day
const MINIMUM_PAID_TICKET_SPOTS = 10;
const MINIMUM_TICKET_PRICE_IN_WEI = ethers.utils.parseEther('0.001');
const FOUNDERS_KEY_CONTRACT_ADDRESS = ethers.constants.AddressZero;
const FOUNDERS_KEY_PLACEHOLDER_ADDRESS =ethers.constants.AddressZero;


async function main()  {
  const [deployer] = await ethers.getSigners();

  const dirPath = `data`;
  const network = hre.network.name;
  createDir(`/${dirPath}/${network}`);

  console.log(
    "Deploying contracts with the account:",
    deployer.address
  );
  console.log("Deploying L1NaffleDiamond..");
  const l1NaffleDiamondImpl: L1NaffleDiamond =
    await new L1NaffleDiamond__factory(deployer).deploy(
    deployer.address,
    MINIMUM_NAFFLE_DURATION,
    MINIMUM_PAID_TICKET_SPOTS,
    MINIMUM_TICKET_PRICE_IN_WEI,
    FOUNDERS_KEY_CONTRACT_ADDRESS,
    FOUNDERS_KEY_PLACEHOLDER_ADDRESS,
    {
      gasPrice: ethers.utils.parseUnits('20', 'gwei'),
      gasLimit: 4000000,
    });
  console.log(
    `Successfully deployed L1NaffleDiamond at ${l1NaffleDiamondImpl.address}`,
  );


  console.log("Deploying Diamond facets..")
  console.log("Deploying L1NaffleBase facet..")
  const l1NaffleBaseImpl: L1NaffleBase =
    await new L1NaffleBase__factory(deployer).deploy({
      gasPrice: ethers.utils.parseUnits('20', 'gwei'),
      gasLimit: 4000000,
    });
  console.log(
    `Successfully deployed L1NaffleBase facet at ${l1NaffleBaseImpl.address}`,
  )

  console.log("Deploying L1NaffleAdmin facet..")
  const l1NaffleAdminImpl: L1NaffleAdmin =
    await new L1NaffleAdmin__factory(deployer).deploy({
      gasPrice: ethers.utils.parseUnits('20', 'gwei'),
      gasLimit: 4000000,
    });

  console.log(
    `Successfully deployed L1NaffleAdmin facet at ${l1NaffleAdminImpl.address}`,
  )

  console.log("Deploying L1NaffleView facet..")
  const l1NaffleViewImpl: L1NaffleView =
    await new L1NaffleView__factory(deployer).deploy({
      gasPrice: ethers.utils.parseUnits('20', 'gwei'),
      gasLimit: 4000000,
    });

  console.log(
    `Successfully deployed L1NaffleView facet at ${l1NaffleViewImpl.address}`,
  )

  console.log("Getting selectors for diamond..")

  const ERC165Selectors = new Set();
  const IERC165 = ERC165Base__factory.createInterface();
  IERC165.fragments.map((f) => ERC165Selectors.add(IERC165.getSighash(f)));
  const OwnableSelectors = new Set();
  const IOwnable = Ownable__factory.createInterface();
  IOwnable.fragments.map((f) => OwnableSelectors.add(IOwnable.getSighash(f)));
  const AccessControlSelectors = new Set();
  const IAccessControl = AccessControl__factory.createInterface();
  IAccessControl.fragments.map((f) =>
    AccessControlSelectors.add(IAccessControl.getSighash(f)),
  );

  const l1NaffleDiamondSelectors = new Set();

  const l1NaffleDiamondOriginalCuts = Object.keys(l1NaffleDiamondImpl.interface.functions)
  .map((fn) => l1NaffleDiamondImpl.interface.getSighash(fn));

  console.log("l1nafflediamondoriginalcuts: ", l1NaffleDiamondOriginalCuts)

  const l1NaffleDiamondCuts = [
    l1NaffleBaseImpl,
    l1NaffleViewImpl,
    l1NaffleAdminImpl
  ].map((facet) => {
    return {
      target: facet.address,
      action: 0,
      selectors: Object.keys(facet.interface.functions)
        .filter(
          (fn) => !l1NaffleDiamondSelectors.has(fn) && l1NaffleDiamondSelectors.add(fn),
        )
        .filter((fn) => !ERC165Selectors.has(facet.interface.getSighash(fn)))
        .filter((fn) => !AccessControlSelectors.has(facet.interface.getSighash(fn)))
        .filter((fn) => !OwnableSelectors.has(facet.interface.getSighash(fn)))
        // filter fn is not in original diamond
        .filter((fn) => !l1NaffleDiamondOriginalCuts.includes(facet.interface.getSighash(fn)))

        .map((fn) => facet.interface.getSighash(fn)),
    };
  });

  console.log("Cutting facets into diamond..")

  try {
    const l1NaffleDiamondCutTx = await l1NaffleDiamondImpl
      .connect(deployer)
      .diamondCut(l1NaffleDiamondCuts, ethers.constants.AddressZero, '0x', {
        gasPrice: ethers.utils.parseUnits('20', 'gwei'),
        gasLimit: 4000000,
      });

    await l1NaffleDiamondCutTx.wait();
    console.log('Successfully cut L1Naffle facets into L1NaffleDiamond');
  } catch (err) {
    console.log('An error occurred: ', err);
  }

  const l1NaffleDiamondAddresses: L1NaffleDiamondAddresses = {
    L1NaffleDiamond: l1NaffleDiamondImpl.address,
    L1NaffleBase: l1NaffleBaseImpl.address,
    L1NaffleAdmin: l1NaffleAdminImpl.address,
    L1NaffleView: l1NaffleViewImpl.address,
  };

  createFile(
    `${dirPath}/${network}/L1NaffleDiamondAddresses.json`,
    JSON.stringify(l1NaffleDiamondAddresses, null, 2),
  );

  console.log('L1NaffleDiamondAddresses: ', l1NaffleDiamondAddresses);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });



