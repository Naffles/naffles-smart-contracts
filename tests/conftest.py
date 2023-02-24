import pytest
from brownie import (
    accounts,
    TestNaffleDiamond,
    TestValueFacet,
    TestValueFacetUpgraded,
    SoulboundFoundersKey,
    FoundersKeyStaking,
    ERC721AMock,
    L1NaffleDiamond,
    L1NaffleBase,
    L1NaffleAdmin,
    L1NaffleView,
)
from brownie.network.account import _PrivateKeyAccount


@pytest.fixture
def admin() -> _PrivateKeyAccount:
    return accounts[0]


@pytest.fixture
def address() -> _PrivateKeyAccount:
    return accounts[1]


@pytest.fixture
def from_address(address) -> dict:
    return {"from": address}


@pytest.fixture
def private_key() -> str:
    return "0b1ce493b94b0ebb664d355548c097f4bab74b5cb55fc5feb4c5fcddb67484e8"


@pytest.fixture
def from_admin(admin) -> dict:
    return {"from": admin}


@pytest.fixture()
def deployed_test_naffle_diamond(from_admin) -> TestNaffleDiamond:
    diamond = TestNaffleDiamond.deploy(from_admin)
    return diamond


@pytest.fixture()
def deployed_l1_naffle_diamond(from_admin) -> L1NaffleDiamond:
    diamond = L1NaffleDiamond.deploy(from_admin)
    return diamond


@pytest.fixture()
def deployed_l1_naffle_base_facet(from_admin) -> L1NaffleBase:
    facet = L1NaffleBase.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l1_naffle_admin_facet(from_admin) -> L1NaffleAdmin:
    facet = L1NaffleAdmin.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l1_naffle_view_facet(from_admin) -> L1NaffleView:
    facet = L1NaffleView.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_test_facet(from_admin) -> TestValueFacet:
    facet = TestValueFacet.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_test_facet_upgraded(from_admin) -> TestValueFacetUpgraded:
    facet = TestValueFacetUpgraded.deploy(from_admin)
    return facet


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
