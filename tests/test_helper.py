import datetime

import brownie

STANDARD_NAFFLE_TYPE = 0
UNLIMITED_NAFFLE_TYPE = 1

PLATFORM_FEE = 100
FREE_TICKET_RATIO = 100
NAFFLE_ID = 1

PAID_TICKET_SPOTS = 2
TICKET_PRICE = 10

DEFAULT_END_DATE = datetime.datetime.now().timestamp() + 1000

ERC721 = 0
ERC1155 = 1

NFT_ID = 1


def create_naffle_and_mint_tickets(
    admin,
    address,
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_view_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_base_facet,
    deployed_erc721a_mock,
):
    from tests.contracts.naffle.zksync.test_l2_naffle_diamond import \
        setup_l2_naffle_diamond_with_facets
    from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_base import \
        setup_paid_ticket_contract
    from tests.contracts.naffle.zksync.test_l2_naffle_base import \
        setup_l2_naffle_contract
    from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_diamond import \
        setup_paid_ticket_diamond_with_facets

    (
        naffle_access_control,
        naffle_base_facet,
        naffle_admin_facet,
        naffle_view_facet,
    ) = setup_l2_naffle_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )

    (
        paid_access_control,
        paid_base_facet,
        paid_admin_facet,
        paid_view_facet,
    ) = setup_paid_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )

    # We set admin as the l1 contract, so we can call create naffle from admin.
    setup_l2_naffle_contract(
        naffle_admin_facet, admin, deployed_l2_paid_ticket_diamond, from_admin
    )
    setup_paid_ticket_contract(paid_admin_facet, deployed_l2_naffle_diamond, from_admin)

    naffle_base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            address,
            NAFFLE_ID,
            NFT_ID,
            PAID_TICKET_SPOTS,
            TICKET_PRICE,
            DEFAULT_END_DATE,
            STANDARD_NAFFLE_TYPE,
            ERC721,
        ),
        from_admin,
    )

    naffle_base_facet.buyTickets(2, 1, {"from": address, "value": 20})