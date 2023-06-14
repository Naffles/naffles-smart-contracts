import brownie

from scripts.util import get_error_message
from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_diamond import (
    setup_paid_ticket_diamond_with_facets as setup_paid_ticket_diamond,
)
from tests.test_helper import create_naffle_and_mint_tickets, NAFFLE_ID, TICKET_PRICE


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

    with brownie.reverts(get_error_message("NotAllowed")):
        base_facet.mintTickets(admin, 1, 1, 10, 0, from_admin)


def test_mint_tickets_for_address(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )
    assert (
        brownie.interface.IERC721Base(
            l2_diamonds.deployed_l2_paid_ticket_diamond.address
        ).balanceOf(address, {"from": address})
        == 2
    )


def test_get_owner_of_naffle_ticket_id(
    admin,
    address,
    from_admin,
    from_address,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200
    )
    naffle_id = 1
    ticket_id = 1
    assert l2_diamonds.paid_view_facet.getOwnerOfNaffleTicketId(
        naffle_id, ticket_id, from_address) == address.address


def test_refund_and_burn_tickets_success(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )
    ticket_id_on_naffle = 1

    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)
    # get the eth balance of the naffle_admin_facet
    eth_balance_before = l2_diamonds.naffle_admin_facet.balance()
    print("eth_balance_before", eth_balance_before)
    print("ticket price", TICKET_PRICE)
    l2_diamonds.paid_base_facet.refundAndBurnTickets(
        NAFFLE_ID, [ticket_id_on_naffle], address, from_address
    )

    ticket = l2_diamonds.paid_view_facet.getTicketById(1)
    assert ticket == (0, 0, 0, False)