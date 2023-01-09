from brownie import SoulboundFoundersKey, accounts, 

def deploy(private_key: str, _foundersKeyAddress: str):
    account = accounts.add(private_key)
    SoulboundFoundersKey.deploy(account.address, _foundersKeyAddress, {'from': account})
