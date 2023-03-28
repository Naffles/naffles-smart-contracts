from brownie import Contract
from scripts.staking.deploy_staking_contract import (FoundersKeyStaking,
                                                     SoulboundFoundersKey,
                                                     deploy)


def test_deploy_staking_contract(admin, deployed_erc721a_mock):
    soulbound = SoulboundFoundersKey.deploy(
        deployed_erc721a_mock.address,
        {"from": admin},
    )
    address = deploy(admin, deployed_erc721a_mock.address, soulbound.address, False)
    proxy = Contract.from_abi("FoundersKeyStaking", address, FoundersKeyStaking[0].abi)
    assert proxy
    assert soulbound.hasRole(soulbound.STAKING_CONTRACT_ROLE(), proxy.address)
