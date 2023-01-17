from ..tokens.deploy_soulbound_contract import deploy as deploy_soulbound
from .deploy_staking_contract import deploy as deploy_staking


def deploy(private_key: str, founders_key_address: str, publish_source: bool = True):
    soulbound_address = deploy_soulbound(
        private_key, founders_key_address, publish_source
    )

    staking_address = deploy_staking(
        private_key, founders_key_address, soulbound_address, publish_source
    )
    print(f"Founders Key Address: {founders_key_address}")
    print(f"Staking Address: {staking_address}")
    print(f"Soulbound Address: {soulbound_address}")
    return soulbound_address, staking_address
