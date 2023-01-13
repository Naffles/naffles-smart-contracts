import pytest

from brownie import (
    SoulboundFoundersKey,
    FoundersKeyStaking,
    accounts,
    ERC721AMock,
)
from brownie.network.account import Account
from brownie.network.contract import ContractContainer


@pytest.fixture
def admin() -> Account:
    return accounts[0]


@pytest.fixture
def from_admin(admin) -> dict:
    return {"from": admin}


@pytest.fixture
def address() -> Account:
    return accounts[1]


@pytest.fixture
def from_address(address) -> dict:
    return {"from": address}


@pytest.fixture
def deployed_erc721a_mock(from_admin) -> ERC721AMock:
    return ERC721AMock.deploy(from_admin)


@pytest.fixture
def deployed_soulbound(
    deployed_erc721a_mock, from_admin, admin
) -> SoulboundFoundersKey:
    soulbound = SoulboundFoundersKey.deploy(deployed_erc721a_mock.address, from_admin)
    soulbound.grantRole(soulbound.STAKING_CONTRACT_ROLE(), admin.address, from_admin)
    return soulbound


@pytest.fixture
def deployed_founders_key_staking(
    deployed_soulbound, deployed_erc721a_mock, from_admin
) -> FoundersKeyStaking:
    staking = FoundersKeyStaking.deploy(
        deployed_erc721a_mock.address, deployed_soulbound.address, from_admin
    )
    deployed_soulbound.grantRole(
        deployed_soulbound.STAKING_CONTRACT_ROLE(), staking.address, from_admin
    )
    return staking
