import brownie
from brownie import accounts

from scripts.util import get_error_message
from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_diamond import (
    setup_paid_ticket_diamond_with_facets as setup_paid_ticket_diamond,
)
from tests.test_helper import create_naffle_and_mint_tickets, NAFFLE_ID


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


def test_detach_and_burn_ticket(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )
    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)
    l2_diamonds.paid_base_facet.detachAndBurnTicket(NAFFLE_ID, 1, address, {"from": accounts.at(l2_diamonds.naffle_base_facet.address, force=True)})

    assert (
        brownie.interface.IERC721Base(
            l2_diamonds.deployed_l2_paid_ticket_diamond.address
        ).balanceOf(address, {"from": address}) == 1
    )

    assert l2_diamonds.paid_view_facet.getTotalSupply(from_admin) == 1
    assert l2_diamonds.paid_view_facet.getTicketById(1, from_admin) == (0, 0, 0, False)
    assert l2_diamonds.paid_view_facet.getTicketByIdOnNaffle(1, 1, from_admin) == (0, 0, 0, False)


def test_detach_and_burn_ticket_not_cancelled(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )
    with brownie.reverts(get_error_message("NaffleNotCancelled", ['uint8'], [0])):
        l2_diamonds.paid_base_facet.detachAndBurnTicket(NAFFLE_ID, 1, address, {"from": accounts.at(l2_diamonds.naffle_base_facet.address, force=True)})


def test_detach_and_burn_ticket_invalid_id(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )
    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)
    with brownie.reverts(get_error_message("InvalidTicketId", ['uint256'], [4])):
        l2_diamonds.paid_base_facet.detachAndBurnTicket(NAFFLE_ID, 4, address, {"from": accounts.at(l2_diamonds.naffle_base_facet.address, force=True)})


def test_detach_and_burn_ticket_not_owner(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )
    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)
    with brownie.reverts(get_error_message("NotTicketOwner", ['address'], [admin.address])):
        l2_diamonds.paid_base_facet.detachAndBurnTicket(NAFFLE_ID, 1, admin, {"from": accounts.at(l2_diamonds.naffle_base_facet.address, force=True)})