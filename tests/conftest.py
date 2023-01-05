import os
import pytest
from brownie import (
    accounts,
    NaffleDiamond,
    TestValueFacet,
    TestValueFacetUpgraded,
    NaffleTicketFacet
)


@pytest.fixture
def admin():
    return accounts[0]


@pytest.fixture
def from_admin(admin):
    return {"from": admin}


@pytest.fixture()
def deployed_naffle_diamond(from_admin):
    diamond = NaffleDiamond.deploy(from_admin)
    return diamond


@pytest.fixture()
def deployed_test_facet(from_admin):
    facet = TestValueFacet.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_test_facet_upgraded(from_admin):
    facet = TestValueFacetUpgraded.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_naffle_ticket_facet(from_admin):
    facet = NaffleTicketFacet.deploy(from_admin)
    return facet


@pytest.fixture()
def root_directory():
    return os.getcwd()
