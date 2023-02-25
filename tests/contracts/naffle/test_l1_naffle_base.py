import datetime

import brownie
import web3

from scripts.util import ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.test_l1_naffle_diamond import \
    setup_diamond_with_facets

STANDARD_NAFFLE_TYPE = 0
UNLIMITED_NAFFLE_TYPE = 1


def _setup_contract(admin_facet, deployed_founders_key_staking, from_admin):
    admin_facet.setMinimumNaffleDuration(2, from_admin)
    admin_facet.setMinimumPaidTicketSpots(2, from_admin)
    admin_facet.setZkSyncAddress(ZKSYNC_ADDRESS, from_admin)
    admin_facet.setZkSyncNaffleContractAddress(ZKSYNC_ADDRESS, from_admin)
    admin_facet.setFoundersKeyAddress(deployed_founders_key_staking.address, from_admin)
    admin_facet.setFoundersKeyPlaceholderAddress(deployed_founders_key_staking.address, from_admin)


def test_create_naffle_not_allowed(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    _setup_contract(admin_facet, deployed_erc721a_mock, from_admin)

    nft_id = 1
    minimum_paid_ticket_spots = 2
    ticket_price = 10

    with brownie.reverts(get_error_message("NotAllowed()")):
        base_facet.createNaffle(
            deployed_founders_key_staking.address,
            nft_id,
            minimum_paid_ticket_spots,
            ticket_price,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            from_address
        )

def atest_create_naffle_invalid_end_time(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    _setup_contract(admin_facet, deployed_founders_key_staking, from_admin)

    nft_id = 1
    minimum_paid_ticket_spots = 2
    ticket_price = 10

    with brownie.reverts(get_error_message("INVALID_END_TIME()")):
        base_facet.createNaffle(
            deployed_erc721a_mock.address,
            nft_id,
            minimum_paid_ticket_spots,
            ticket_price,
            datetime.datetime.now().timestamp() - 1000,
            1,
            from_address
        )