import pytest

from brownie import (
    SoulboundFoundersKey, 
    FoundersKeyStaking,
    accounts, ERC721AMock,
)
        

@pytest.fixture
def admin():
    return accounts[0]


@pytest.fixture
def from_admin(admin):
    return {'from': admin}


@pytest.fixture
def address():
    return accounts[1]


@pytest.fixture
def from_address(address):
    return {'from': address}


@pytest.fixture
def deployed_erc721a_mock(from_admin):
    return ERC721AMock.deploy(from_admin)


@pytest.fixture
def deployed_soulbound(deployed_erc721a_mock, admin, from_admin):
    return SoulboundFoundersKey.deploy(
        admin.address,
        deployed_erc721a_mock.address,
        from_admin
    ), deployed_erc721a_mock


@pytest.fixture
def deployed_founders_key_staking(deployed_soulbound, from_admin):
    return FoundersKeyStaking.deploy(
        deployed_soulbound[1].address,
        deployed_soulbound[0].address,
        from_admin
    ), deployed_soulbound[0], deployed_soulbound[1]

