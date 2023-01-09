from ..tokens.deploy_soulbound_contract import deploy as deploy_soulbound
from .deploy_staking_contract import deploy as deploy_staking


def deploy(private_key: str, founders_key_address: str):
    soulbound_address = deploy_soulbound(private_key, founders_key_address)

    staking_address = deploy_staking(
        private_key, founders_key_address, soulbound_address
    )
    print(f"Founders Key Address: {founders_key_address}")
    print(f"Staking Address: {staking_address}")
    return soulbound_address, staking_address
