import datetime

import brownie
from brownie import interface

from scripts.util import NULL_ADDRESS, ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.ethereum.test_l1_naffle_base import \
    STANDARD_NAFFLE_TYPE
from tests.contracts.naffle.zksync.test_l2_naffle_base import \
    setup_l2_naffle_contract, NAFFLE_ID, NFT_ID, PAID_TICKET_SPOTS, \
    TICKET_PRICE, ERC721
from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_diamond import \
    setup_paid_ticket_diamond_with_facets as setup_paid_ticket_diamond
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import \
    setup_diamond_with_facets as setup_naffle_diamond


def setup_paid_ticket_contract(admin_facet, naffle_contract, from_admin):
    admin_facet.setL2NaffleContractAddress(naffle_contract.address, from_admin)


def test_mint_tickets_not_allowed(
    admin,
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
    deployed_l2_naffle_diamond,
):
    access_control, base_facet, admin_facet, view_facet = setup_paid_ticket_diamond(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )
    setup_paid_ticket_contract(admin_facet, deployed_l2_naffle_diamond, from_admin)

    with brownie.reverts(get_error_message("NotAllowed", [], [])):
        base_facet.mintTickets(admin, 1, 1, 10, from_admin)


def test_mint_tickets_for_address(
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
    deployed_erc721a_mock
):
    naffle_access_control, naffle_base_facet, naffle_admin_facet, naffle_view_facet = setup_naffle_diamond(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )

    paid_access_control, paid_base_facet, paid_admin_facet, paid_view_facet = setup_paid_ticket_diamond(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )

    setup_l2_naffle_contract(naffle_admin_facet, admin, deployed_l2_paid_ticket_diamond, from_admin)
    setup_paid_ticket_contract(paid_admin_facet, deployed_l2_naffle_diamond, from_admin)

    naffle_base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            address,
            NAFFLE_ID,
            NFT_ID,
            PAID_TICKET_SPOTS,
            TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            ERC721,
        ),
        from_admin,
    )

    naffle_base_facet.buyTickets(2, 1, {"from": address, "value": 20})


    assert interface.IERC721Base(deployed_l2_paid_ticket_diamond.address).balanceOf(address, from_admin) == 2