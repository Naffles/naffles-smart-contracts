import {Provider, Wallet} from "zksync-web3";

export const getRPCEndpoint = (network: string) => {
  if (network === "goerli" || network == "zkSyncTestnet") {
    return "https://testnet.era.zksync.dev"
  } else {
    return "https://mainnet.era.zksync.io"
  }
}

export const getInfuraURL = (network: string) => {
  if (network === "goerli" || network == "zkSyncTestnet") {
    return "https://goerli.infura.io/v3/" + process.env.INFURA_API_KEY
  } else {
    return "https://mainnet.infura.io/v3/" + process.env.INFURA_API_KEY
  }
}

export const getPrivateKey = (alternative: boolean = false) => {
  let PRIVATE_KEY = "";
  if (!alternative) {
    PRIVATE_KEY = process.env.PRIVATE_KEY || "";
  } else {
    PRIVATE_KEY = process.env.PRIVATE_KEY_ALTERNATIVE || "";
  }

  if (PRIVATE_KEY == "") {
    throw new Error("Wallet private key is not configured in env file");
  }
  return PRIVATE_KEY
}