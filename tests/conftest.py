import pytest

from brownie import (
    SoulboundFoundersKey, 
    accounts, 
    ERC721AMock
)
from brownie.network.account import Account


@pytest.fixture
def admin() -> Account:
    return accounts[0]


@pytest.fixture
def from_admin(admin) -> dict:
    return {'from': admin}


@pytest.fixture
def address() -> Account:
    return accounts[1]


@pytest.fixture
def from_address(address) -> dict:
    return {'from': address}


@pytest.fixture
def deployed_erc721a_mock(from_admin) -> ERC721AMock:
    return ERC721AMock.deploy(from_admin)


@pytest.fixture
def deployed_soulbound(deployed_erc721a_mock, admin, from_admin) -> SoulboundFoundersKey:
    return SoulboundFoundersKey.deploy(
        admin.address,
        deployed_erc721a_mock.address,
        from_admin
    ), deployed_erc721a_mock
