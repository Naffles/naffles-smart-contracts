import pytest
from brownie import (
    accounts, 
    NaffleDiamond,
    TestValueFacet,
    TestValueStorage
)


@pytest.fixture
def admin():
    return accounts[0]


@pytest.fixture
def from_admin(admin):
    return {'from': admin}


@pytest.fixture()
def deployed_naffle_diamond(from_admin):
    diamond = NaffleDiamond.deploy(from_admin)
    return diamond


@pytest.fixture()
def deployed_test_facet(from_admin):
    facet = TestValueFacet.deploy(from_admin)
    return facet 

@pytest.fixture()
def deployed_test_storage(from_admin):
    storage = TestValueStorage.deploy(from_admin)
    return storage