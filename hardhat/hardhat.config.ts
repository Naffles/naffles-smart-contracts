import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();

import "@matterlabs/hardhat-zksync-deploy";
import "@matterlabs/hardhat-zksync-solc";
import '@typechain/hardhat'
import '@nomiclabs/hardhat-ethers'

require('hardhat-dependency-compiler');

const INFURA_API_KEY = process.env.INFURA_API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY

const zkSyncTestnet =
  process.env.NODE_ENV == "test"
    ? {
        url: "http://localhost:3050",
        ethNetwork: "http://localhost:8545",
        zksync: true,
      }
    : {
        url: "https://testnet.era.zksync.dev",
        ethNetwork: "goerli",
        zksync: true,
      };

module.exports = {
  zksolc: {
    version: "1.3.8",
    compilerSource: "binary",
    settings: {},
  },
  defaultNetwork: "zkSyncTestnet",
  networks: {
    hardhat: {
      zksync: true,
    },
    testnet: {
        url: "http://localhost:3050",
        ethNetwork: "hardhat",
        zksync: true,
    },
    goerli: {
        url: "https://goerli.infura.io/v3/" + INFURA_API_KEY
    },
    zkSyncTestnet,
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 2000,
      }
    }
  },
};
