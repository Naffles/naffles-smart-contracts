from brownie import SoulboundFoundersKey

from scripts.tokens.ethereum.deploy_soulbound_contract import deploy


def test_deploy_soulbound_contract(private_key, deployed_erc721a_mock):
    address = deploy(private_key, deployed_erc721a_mock.address, False)
    contract = SoulboundFoundersKey.at(address)
    assert contract
