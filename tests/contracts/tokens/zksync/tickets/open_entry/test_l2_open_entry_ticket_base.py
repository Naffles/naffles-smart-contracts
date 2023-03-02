import brownie

from scripts.util import get_error_message
from tests.contracts.tokens.zksync.tickets.open_entry.test_l2_open_entry_ticket_diamond import \
    setup_open_entry_ticket_diamond_with_facets


def setup_open_entry_ticket_contract(admin_facet, naffle_contract, from_admin):
    admin_facet.setL2NaffleContractAddress(naffle_contract.address, from_admin)


def test_admin_mint(
    admin,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    base_facet.adminMint(admin, 1, from_admin)
    assert view_facet.getTotalSupply(from_admin) == 1


def test_admin_mint_no_admin(
    admin,
    from_address,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    with brownie.reverts():
        base_facet.adminMint(admin, 1, from_address)

    assert view_facet.getTotalSupply(from_admin) == 0


def test_attach_to_naffle(
    admin,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    setup_open_entry_ticket_contract(admin_facet, admin, from_admin)
    base_facet.adminMint(admin, 1, from_admin)
    base_facet.attachToNaffle(1, [1], 1, admin, from_admin)

    ticket = view_facet.getOpenEntryTicketById(1, from_admin)
    assert ticket == (
        1,
        1,
        False
    )
