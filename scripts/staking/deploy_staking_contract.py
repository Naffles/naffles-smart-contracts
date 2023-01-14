import json

from brownie import FoundersKeyStaking, accounts, SoulboundFoundersKey, Contract

def deploy(
    private_key: str, founders_key_address: str, soulbound_nft_address: str
) -> str:
    account = accounts.add(private_key)
    deployed = FoundersKeyStaking.deploy(
        founders_key_address, soulbound_nft_address, {"from": account}, publish_source=True)

    address = deployed.address

    # open IfoundersKey json file 
    with open("../../build/interfaces/IFoundersKey.json", "r") as f:
        abi = json.load(f)["abi"]

    Contract.from_abi("FoundersKey", founders_key_address, abi).setStakingAddress(address, {"from": account})
    soulbound_contract = SoulboundFoundersKey.at(soulbound_nft_address)
    soulbound_contract.grantRole(
        soulbound_contract.STAKING_CONTRACT_ROLE(), address, {"from": account}
    )

    return address
