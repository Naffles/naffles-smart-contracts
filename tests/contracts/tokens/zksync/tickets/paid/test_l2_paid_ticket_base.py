import datetime

import brownie

from scripts.util import NULL_ADDRESS, ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import (
    setup_diamond_with_facets,
)


def _setup_contract(admin_facet, naffle_contract, from_admin):
    admin_facet.setL2NaffleContractAddress(naffle_contract.address, from_admin)