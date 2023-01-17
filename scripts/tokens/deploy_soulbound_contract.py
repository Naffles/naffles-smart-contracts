from brownie import SoulboundFoundersKey, accounts


def deploy(private_key: str, founders_key_address: str, publish_source: bool = True) -> str:
    account = accounts.add(private_key)
    deployed = SoulboundFoundersKey.deploy(founders_key_address, {"from": account}, publish_source=publish_source)

    print(deployed)
    print(f"Deployed to: {deployed.address}")
    return deployed.address
