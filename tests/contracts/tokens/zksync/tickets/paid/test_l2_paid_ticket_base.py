import datetime

import brownie

from scripts.util import NULL_ADDRESS, ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.zksync.test_l2_naffle_base import setup_l2_naffle_contract
from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_diamond import \
    setup_diamond_with_facets as setup_paid_ticket_diamond
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import \
    setup_diamond_with_facets as setup_naffle_diamond


def setup_paid_ticket_contract(admin_facet, naffle_contract, from_admin):
    admin_facet.setL2NaffleContractAddress(naffle_contract.address, from_admin)


