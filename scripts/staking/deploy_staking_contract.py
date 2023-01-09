from brownie import FoundersKeyStaking, accounts, Contract 

def deploy(private_key: str, founders_key_address: str, soulbound_nft_address: str) -> str:
    account = accounts.add(private_key)
    deployed = FoundersKeyStaking.deploy(founders_key_address,  soulbound_nft_address, {'from': account}, publish_source=True)
    print(f"Deployed to: {deployed.address}")
    
    soulbound_contract = Contract.from_explorer(soulbound_nft_address)
    soulbound_contract.grantRole(soulbound_contract.STAKING_CONTRACT_ROLE(), 
                                 deployed.address, {'from': account})
     
    return deployed.address
