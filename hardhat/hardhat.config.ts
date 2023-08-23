import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();

import "@matterlabs/hardhat-zksync-deploy";
import "@matterlabs/hardhat-zksync-solc"; // comment out to compile / deploy for ethereum.
import "@matterlabs/hardhat-zksync-verify"; // comment out to compile / deploy for ethereum.
import '@typechain/hardhat'
import '@nomiclabs/hardhat-ethers'
// import "@nomiclabs/hardhat-etherscan"; // comment out to compile / deploy for zksync.

require("./tasks/ethereum/deploy_erc721a_mock")
require("./tasks/ethereum/mint_mock_nfts")

require("./tasks/ethereum/naffle/l1_naffle_base/create_naffle")
require("./tasks/ethereum/naffle/l1_naffle_base/consume_set_winner_message")

require("./tasks/ethereum/naffle/l1_naffle_admin/init_l1_naffle_contract")
require("./tasks/ethereum/naffle/l1_naffle_admin/set_founders_key_address")

require("./tasks/ethereum/naffle/l1_naffle_view/read_l1_naffle_variables")

require("./tasks/zksync/naffle/l2_naffle_base/create_l2_naffle")
require("./tasks/zksync/naffle/l2_naffle_base/buy_tickets");
require("./tasks/zksync/naffle/l2_naffle_base/mint_and_attach_open_entry_tickets");
require("./tasks/zksync/naffle/l2_naffle_base/cancel_naffle");
require("./tasks/zksync/naffle/l2_naffle_base/draw_winner");
require("./tasks/zksync/naffle/l2_naffle_base/refund_tickets");

require("./tasks/zksync/naffle/l2_naffle_view/read_l2_naffle_variables");

require("./tasks/zksync/naffle/l2_naffle_admin/set_l1_naffle_contract");
require("./tasks/zksync/naffle/l2_naffle_admin/set_l2_ticket_contracts");
require("./tasks/zksync/naffle/l2_naffle_admin/cancel_naffle");

require("./tasks/zksync/tokens/paid/paid_ticket_view/read_paid_ticket_variables");

require("./tasks/zksync/tokens/paid/paid_ticket_admin/set_l2_naffle_contract");

require("./tasks/zksync/tokens/paid/paid_ticket_base/refund_and_burn_ticket");


require("./tasks/zksync/tokens/open_entry/open_entry_ticket_view/read_open_entry_ticket_variables");

require("./tasks/zksync/tokens/open_entry/open_entry_ticket_admin/set_l2_naffle_contract");

require("./tasks/zksync/tokens/open_entry/open_entry_ticket_base/detach_tickets");

const INFURA_API_KEY = process.env.INFURA_API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY

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
    zksynclocalhost: {
        url: "http://localhost:3050",
        ethNetwork: "hardhat",
        zksync: true,
    },
    goerli: {
        url: "https://goerli.infura.io/v3/" + INFURA_API_KEY,
        accounts: [PRIVATE_KEY]
    },
    polygon: {
        url: "https://polygon-mainnet.infura.io/v3/" + INFURA_API_KEY,
        accounts: [PRIVATE_KEY]
    },
    mumbai: {
        url: "https://polygon-mumbai.infura.io/v3/" + INFURA_API_KEY,
        accounts: [PRIVATE_KEY]
    },
    zkSyncTestnet: {
      url: "https://testnet.era.zksync.dev",
      ethNetwork: "goerli",
      zksync: true,
      verifyURL: "https://zksync2-testnet-explorer.zksync.dev/contract_verification",
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
    customChains: [
      {
        network: "polygonMumbai",
        chainId: 80001,
        urls: {
          apiURL: "https://api-testnet.polygonscan.com",
          browserURL: "https://mumbai.polygonscan.com"
        }
      }
    ]
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
