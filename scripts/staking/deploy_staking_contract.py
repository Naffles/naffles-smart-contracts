from brownie import (Contract, ERC1967Proxy, FoundersKeyStaking,
                     SoulboundFoundersKey, accounts, interface)


def deploy(
    private_key: str,
    founders_key_address: str | None = None,
    soulbound_nft_address: str | None = None,
    publish_source: bool = True,
) -> str:
    account = accounts.add(private_key)
    deployed = FoundersKeyStaking.deploy(
        {"from": account},
        publish_source=publish_source,
    )

    proxy = ERC1967Proxy.deploy(deployed.address, b"", {"from": account})
    proxy = Contract.from_abi("FoundersKeyStaking", proxy.address, deployed.abi)
    proxy.initialize({"from": account})

    address = proxy.address
    interface.IFoundersKey(
        founders_key_address or proxy.FoundersKeyAddress()
    ).setStakingAddress(address, {"from": account})
    soulbound_contract = SoulboundFoundersKey.at(
        soulbound_nft_address or proxy.SoulboundFoundersKeyAddress()
    )
    soulbound_contract.grantRole(
        soulbound_contract.STAKING_CONTRACT_ROLE(), address, {"from": account}
    )

    return address
