import brownie
from brownie import L2OpenEntryTicketAdmin, interface

from scripts.util import add_facet, get_selectors
from tests.contracts.tokens.zksync.tickets.open_entry.test_l2_open_entry_ticket_base import (
    setup_open_entry_ticket_contract,
)
from tests.contracts.tokens.zksync.tickets.open_entry.test_l2_open_entry_ticket_diamond import (
    setup_open_entry_ticket_diamond_with_facets,
)
from tests.test_helper import create_naffle_and_mint_tickets

TEST_ADDRESS = "0xb3D0248016434793037ED3abF8865d701f40AA82"


def test_admin_facet_deployment(
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_admin_facet,
):
    start_facet_number = len(deployed_l2_open_entry_ticket_diamond.facets())

    add_facet(
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_admin_facet,
        from_admin,
        get_selectors(L2OpenEntryTicketAdmin),
    )

    assert len(deployed_l2_open_entry_ticket_diamond.facets()) == start_facet_number + 1


def test_get_and_set_l2_naffle_contract_address(
    admin,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )
    admin_facet.setL2NaffleContractAddress(TEST_ADDRESS, from_admin)

    assert view_facet.getL2NaffleContractAddress() == TEST_ADDRESS


def test_set_l2_naffle_contract_address_not_admin(
    from_admin,
    from_address,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )
    with brownie.reverts():
        admin_facet.setL2NaffleContractAddress(TEST_ADDRESS, from_address)


def test_get_and_set_admin_address(
    address,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )
    admin_facet.setAdmin(address, from_admin)

    assert access_control.hasRole(view_facet.getAdminRole(), address)


def test_set_admin_address_not_admin(
    address,
    from_admin,
    from_address,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )
    with brownie.reverts():
        admin_facet.setAdmin(address, from_address)


def test_get_open_entry_ticket_by_id(
    admin,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    setup_open_entry_ticket_contract(admin_facet, admin, from_admin)
    amount = 1
    admin_facet.adminMint(admin, amount, from_admin)
    naffle_id = 1
    ticket_id_on_naffle = 1

    base_facet.attachToNaffle(
        naffle_id, [ticket_id_on_naffle], ticket_id_on_naffle, admin, from_admin
    )

    ticket = view_facet.getOpenEntryTicketById(1, from_admin)

    assert ticket == (naffle_id, ticket_id_on_naffle, False)


def test_get_total_supply(
    admin,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    setup_open_entry_ticket_contract(admin_facet, admin, from_admin)
    amount = 2
    admin_facet.adminMint(admin, amount, from_admin)

    assert view_facet.getTotalSupply() == 2


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
    l2_diamonds.naffle_base_facet.useOpenEntryTickets(
        [ticket_id], naffle_id, from_address
    )
    assert l2_diamonds.open_entry_view_facet.getOwnerOfNaffleTicketId(naffle_id, ticket_id, from_address) == address.address

