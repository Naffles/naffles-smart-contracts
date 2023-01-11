
from brownie import FoundersKeyStaking, accounts, Contract, SoulboundFoundersKey


minted_user_pk = "803bba04c8c97f4110fd4551ab1569a0c94a2e9c6c47571b8c7fc00d7d0797f1"

def stake_nft(founders_key_address: str, staking_address: str, nft_id: int):
    user = accounts.add(minted_user_pk)
    staked_contract = FoundersKeyStaking.at(staking_address)
    founders_key = SoulboundFoundersKey.at(founders_key_address)
    founders_key.setApprovalForAll(staking_address, True, {"from": user})
    staked_contract.stake(nft_id, 1, {'from': user})
