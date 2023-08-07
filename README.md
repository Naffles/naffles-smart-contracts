# naffles-smart-contracts
Smart contract for the Naffles marketplace.

## Deployment
Because zksync only supports hardhat for now a hardhat folder is included where the deployments scripts for the naffle 
related contracts is located.

### Compiling the contracts
To compile the contracts for zksync run the following command:
```cd hardat && npx hardhat compile```

To compile the contracts for ethereum, you must first comment out line ```import "@matterlabs/hardhat-zksync-solc";```
in the hardhat.config.js file and then run the following command:
```cd hardat && npx hardhat compile```


### Deploying the contracts

*After deployment the contract addresses can be found in the data folder*    

#### 1. deploy ethereum contract(s)
To deploy the contracts for ethereum, call the following from the hardhat folder 

```foundersKeyAddress=0x.. foundersKeyPlaceholderAddress=0x npx hardhat run --network networkName deploy/deploy_l1_contracts```

when the foundersKeyAddress or the foundersKeyPlaceholderAddress is not provided, the script will deploy a erc721 mock. 

#### 2. deploy zksync contract

To deploy the contracts for zksync, call the following from the hardhat folder 

```l1NaffleAddress=0x.. deployerPrivateKey=0x.. yarn hardhat deploy-zksync --script deploy/deploy_l2_diamonds.ts --network networkName```

#### 3. update the l1 naffle diamaond contract

To update the l1 naffle diamond contract with the l2 naffle contract address, call the following from the hardhat folder 

```l2NaffleAddress=0x l1NaffleAddress=0x npx hardhat run --network networkname localhost deploy/update_l1_with_l2_contract```
