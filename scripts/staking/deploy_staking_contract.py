from brownie import FoundersKeyStaking, ERC721AMock, accounts, SoulboundFoundersKey


def deploy(
    private_key: str, founders_key_address: str, soulbound_nft_address: str
) -> str:
    account = accounts.add(private_key)
    deployed = FoundersKeyStaking.deploy(
        founders_key_address, soulbound_nft_address, {"from": account}, publish_source=True)

    address = deployed.address
    print(f"Deployed to: {address}")
    ERC721AMock.at(founders_key_address).setStakingAddress(address, {"from": account})
    soulbound_contract = SoulboundFoundersKey.at(soulbound_nft_address)
    soulbound_contract.grantRole(
        soulbound_contract.STAKING_CONTRACT_ROLE(), address, {"from": account}
    )

    return address
