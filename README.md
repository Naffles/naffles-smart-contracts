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

#### deploy ethereum contract(s)
To deploy the contracts for ethereum, call the following from the hardhat folder 

```foundersKeyAddress=0x.. foundersKeyPlaceholderAddress=0x 