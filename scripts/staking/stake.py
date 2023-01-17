from brownie import FoundersKeyStaking, accounts

def stake(private_key: str, staking_contract: str): 
    account = accounts.add(private_key)
    FoundersKeyStaking.at(staking_contract).stake(51, 1, {'from': account})

