import brownie
from brownie import ZERO_ADDRESS, L2PaidTicketAdmin, interface

from scripts.util import add_facet, get_selectors, get_error_message
from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_diamond import (
    setup_paid_ticket_diamond_with_facets,
)
from tests.test_helper import NAFFLE_ID, TICKET_PRICE, create_naffle_and_mint_tickets

TEST_ADDRESS = "0xb3D0248016434793037ED3abF8865d701f40AA82"


def test_admin_facet_deployment(
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_admin_facet,
):
    start_facet_number = len(deployed_l2_paid_ticket_diamond.facets())

    add_facet(
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_admin_facet,
        from_admin,
        get_selectors(L2PaidTicketAdmin),
    )

    assert len(deployed_l2_paid_ticket_diamond.facets()) == start_facet_number + 1


def test_get_and_set_l2_naffle_contract_address(
    admin,
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_paid_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )
    admin_facet.setL2NaffleContractAddress(TEST_ADDRESS, from_admin)

    assert view_facet.getL2NaffleContractAddress() == TEST_ADDRESS


def test_set_l2_naffle_contract_address_not_admin(
    from_admin,
    from_address,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_paid_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )
    with brownie.reverts():
        admin_facet.setL2NaffleContractAddress(TEST_ADDRESS, from_address)


def test_get_and_set_admin_address(
    address,
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_paid_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )
    admin_facet.setAdmin(address, from_admin)

    assert access_control.hasRole(view_facet.getAdminRole(), address)


def test_set_admin_address_not_admin(
    address,
    from_admin,
    from_address,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_paid_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )
    with brownie.reverts():
        admin_facet.setAdmin(address, from_address)


def test_get_ticket_by_id(
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

    ticket_id = 1
    ticket = brownie.interface.IL2PaidTicketView(
        l2_diamonds.deployed_l2_paid_ticket_diamond).getTicketById(ticket_id, from_admin)
    assert ticket == (
        TICKET_PRICE,
        NAFFLE_ID,
        ticket_id,
        False
    )


def test_get_ticket_by_id_on_naffle(
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

    ticket_id = 1
    ticket = brownie.interface.IL2PaidTicketView(
        l2_diamonds.deployed_l2_paid_ticket_diamond).getTicketByIdOnNaffle(ticket_id, 1, from_admin)
    assert ticket == (
        TICKET_PRICE,
        NAFFLE_ID,
        ticket_id,
        False
    )


def test_set_base_uri_not_admin(
    admin,
    from_admin,
    from_address,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_paid_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )
    with brownie.reverts():
        admin_facet.setBaseURI("test", from_address)


def test_set_base_uri(
    admin,
    address,
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_view_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_base_facet,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        admin,
        address,
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_view_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_base_facet,
        deployed_erc721a_mock,
    )
    admin_facet = interface.IL2PaidTicketAdmin(
        deployed_l2_paid_ticket_diamond.address
    )
    admin_facet.setBaseURI("base_uri/", from_admin)

    view_facet = interface.IERC721Metadata(
        deployed_l2_paid_ticket_diamond.address
    )
    assert view_facet.tokenURI(1) == 'base_uri/1'
