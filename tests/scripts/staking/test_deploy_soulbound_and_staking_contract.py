from brownie import SoulboundFoundersKey, FoundersKeyStaking

from scripts.staking.deploy_soulbound_and_staking import deploy


def test_deploy_soulbound_and_staking_contract(private_key, deployed_erc721a_mock):
    soulbound, staking = deploy(private_key, deployed_erc721a_mock.address)
    assert FoundersKeyStaking.at(staking)
    assert SoulboundFoundersKey.at(soulbound)
