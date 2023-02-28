import datetime

import brownie

from scripts.util import NULL_ADDRESS, ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import setup_diamond_with_facets

STANDARD_NAFFLE_TYPE = 0
UNLIMITED_NAFFLE_TYPE = 1

PLATFORM_FEE = 100
FREE_TICKET_RATIO = 100


def _setup_contract(admin_facet, zksync_contract, from_admin):
    admin_facet.setPlatformFee(PLATFORM_FEE, from_admin)
    admin_facet.setFreeTicketRatio(FREE_TICKET_RATIO, from_admin)
    admin_facet.setZkSyncAddress(zksync_contract.address, from_admin)


def test_create_naffle_not_allowed(
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    _setup_contract(admin_facet, from_admin["from"], from_admin)
