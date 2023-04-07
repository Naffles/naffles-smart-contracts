import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();

import "@matterlabs/hardhat-zksync-deploy";
import "@matterlabs/hardhat-zksync-solc";

require('hardhat-dependency-compiler');

const INFURA_API_KEY = process.env.INFURA_API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY

console.log("INFURA_API_KEY", INFURA_API_KEY)

module.exports = {
  zksolc: {
    version: "1.3.8",
    compilerSource: "binary",
    settings: {},
  },
  defaultNetwork: "zkSyncTestnet",

  networks: {
    localhost: {
      zksync: true,  // enables zksync in hardhat local network
      ethNetwork: "goerli",
      url: "http://localhost:8545"
    },
    goerli: {
        url: "https://goerli.infura.io/v3/" + INFURA_API_KEY // URL of the Ethereum Web3 RPC (optional)
    },
    zkSyncTestnet: {
      url: "https://zksync2-testnet.zksync.dev",
      ethNetwork: "goerli",
      zksync: true,
    },
  },
  solidity: {
    version: "0.8.17",
  },
};
