import datetime

import brownie

from scripts.util import NULL_ADDRESS, ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import (
    setup_diamond_with_facets,
)


def _setup_contract(admin_facet, naffle_contract, from_admin):
    admin_facet.setL2NaffleContractAddress(naffle_contract.address, from_admin)


def test_buy_tickets_invalid_naffle_id(
    admin,
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )
    _setup_contract(admin_facet, admin, from_admin)
