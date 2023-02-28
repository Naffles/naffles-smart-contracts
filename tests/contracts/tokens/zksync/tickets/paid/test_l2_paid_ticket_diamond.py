from brownie import (
    L2PaidTicketDiamond,
    L2PaidTicketBase,
    L2PaidTicketAdmin,
    L2PaidTicketView,
    accounts,
    interface,
)

from scripts.util import (
    get_selectors,
    remove_duplicated_selectors,
    add_facet,
)


def setup_diamond_with_facets(
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
):
    base_selectors = get_selectors(L2PaidTicketBase)
    admin_selectors = get_selectors(L2PaidTicketAdmin)
    view_selectors = get_selectors(L2PaidTicketView)

    add_facet(
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        from_admin,
        base_selectors,
    )
    add_facet(
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_admin_facet,
        from_admin,
        remove_duplicated_selectors(base_selectors, admin_selectors),
    )
    add_facet(
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_view_facet,
        from_admin,
        remove_duplicated_selectors(base_selectors + admin_selectors, view_selectors),
    )
    access_control = interface.IAccessControl(deployed_l2_paid_ticket_diamond.address)
    base_facet = interface.IL2PaidTicketBase(deployed_l2_paid_ticket_diamond.address)
    admin_facet = interface.IL2PaidTicketAdmin(deployed_l2_paid_ticket_diamond.address)
    view_facet = interface.IL2PaidTicketView(deployed_l2_paid_ticket_diamond.address)
    return access_control, base_facet, admin_facet, view_facet


def test_facet_deployment(
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
):
    start_facet_number = len(deployed_l2_paid_ticket_diamond.facets())

    setup_diamond_with_facets(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )

    assert len(deployed_l2_paid_ticket_diamond.facets()) == start_facet_number + 3
