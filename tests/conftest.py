import os

import pytest
from brownie import (
    accounts,
    Account,
    NaffleDiamond,
    TestValueFacet,
    TestValueFacetUpgraded,
)


@pytest.fixture
def admin() -> Account:
    return accounts[0]


@pytest.fixture
def from_admin(admin) -> dict:
    return {"from": admin}


@pytest.fixture()
def deployed_naffle_diamond(from_admin) -> NaffleDiamond:
    diamond = NaffleDiamond.deploy(from_admin)
    return diamond


@pytest.fixture()
def deployed_test_facet(from_admin) -> TestValueFacet:
    facet = TestValueFacet.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_test_facet_upgraded(from_admin) -> TestValueFacetUpgraded:
    facet = TestValueFacetUpgraded.deploy(from_admin)
    return facet


@pytest.fixture()
def root_directory() -> str:
    return os.getcwd()
