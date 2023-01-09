from brownie import accounts

from ..tokens.deploy_placeholder_contract import deploy as deploy_placeholder
from .deploy_staking_contract import deploy as deploy_staking

def deploy(private_key: str, founders_key_address: str):
    placeholder_address = deploy_placeholder(private_key, founders_key_address)
    soulbound_nft_address = deploy_placeholder(private_key, placeholder_address)
    staking_address = deploy_staking(private_key, founders_key_address, soulbound_nft_address)
    print(f"Founders Key Address: {founders_key_address}")
    print(f"Soulbound NFT Address: {soulbound_nft_address}")
    print(f"Staking Address: {staking_address}")

