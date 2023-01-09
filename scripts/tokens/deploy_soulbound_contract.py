from brownie import SoulboundFoundersKey, accounts 

def deploy(private_key: str, founders_key_address: str) -> str:
    account = accounts.add(private_key)
    deployed = SoulboundFoundersKey.deploy(founders_key_address, {'from': account})

    print(f"Deployed to: {deployed.address}")
    return deployed.address


