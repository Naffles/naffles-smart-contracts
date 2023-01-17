from brownie import FoundersKeyStaking, accounts, SoulboundFoundersKey, Contract
from brownie import interface


def deploy(
    account,
    founders_key_address: str,
    soulbound_nft_address: str,
    publish_source: bool = True,
) -> str:
    deployed = FoundersKeyStaking.deploy(
        founders_key_address,
        soulbound_nft_address,
        {"from": account},
        publish_source=publish_source,
    )

    address = deployed.address
    interface.IFoundersKey(founders_key_address).setStakingAddress(
        address, {"from": account}
    )
    soulbound_contract = SoulboundFoundersKey.at(soulbound_nft_address)
    soulbound_contract.grantRole(
        soulbound_contract.STAKING_CONTRACT_ROLE(), address, {"from": account}
    )

    return address
