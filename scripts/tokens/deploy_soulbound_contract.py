from brownie import SoulboundFoundersKey, accounts


def deploy(
    account, founders_key_address: str, publish_source: bool = True
) -> str:
    deployed = SoulboundFoundersKey.deploy(
        founders_key_address, {"from": account}, publish_source=publish_source
    )

    print(deployed)
    print(f"Deployed to: {deployed.address}")
    return deployed.address
