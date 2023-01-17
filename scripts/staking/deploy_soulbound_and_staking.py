from brownie import accounts

from ..tokens.deploy_soulbound_contract import deploy as deploy_soulbound
from .deploy_staking_contract import deploy as deploy_staking


def deploy():
    soulbound_address = deploy_soulbound(
        accounts.load("naffles"),
        "0xaA7c9180c9453aB91A9dAE5ec1B989D98Ed75F4F"
    )

    staking_address = deploy_staking(
        accounts.load("naffles"),
        "0xaA7c9180c9453aB91A9dAE5ec1B989D98Ed75F4F",
        soulbound_address
    )
    print(f"Staking Address: {staking_address}")
    print(f"Soulbound Address: {soulbound_address}")
    return soulbound_address, staking_address
