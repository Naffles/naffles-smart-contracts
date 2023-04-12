from brownie import (
    L2PaidTicketDiamond,
    L2PaidTicketBase,
    L2PaidTicketAdmin,
    L2PaidTicketView,
    accounts,
    interface,
)
from brownie.network.account import Account

from scripts.util import get_selectors, add_facet, remove_duplicated_selectors


def deploy(
    account: Account | None = None,
    publish_source: bool = True,
):
    if not account:
        account = accounts.load("naffle")

    from_account = {"from": account}
    deployed_l2_paid_ticket_diamond = L2PaidTicketDiamond.deploy(
        {"from": account},
        publish_source=publish_source,
    )

    deployed_l2_paid_ticket_base_facet = L2PaidTicketBase.deploy({"from": account}, publish_source=publish_source)
    deployed_l2_paid_ticket_admin_facet = L2PaidTicketAdmin.deploy({"from": account}, publish_source=publish_source)
    deployed_l2_paid_ticket_view_facet = L2PaidTicketView.deploy({"from": account}, publish_source=publish_source)

    base_selectors = get_selectors(L2PaidTicketBase)
    admin_selectors = get_selectors(L2PaidTicketAdmin)
    view_selectors = get_selectors(L2PaidTicketView)

    add_facet(
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        from_account,
        base_selectors,
    )
    add_facet(
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_admin_facet,
        from_account,
        remove_duplicated_selectors(base_selectors, admin_selectors),
    )
    add_facet(
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_view_facet,
        from_account,
        remove_duplicated_selectors(base_selectors + admin_selectors, view_selectors),
    )

    access_control = interface.IAccessControl(deployed_l2_paid_ticket_diamond.address)
    base_facet = interface.IL2PaidTicketBase(deployed_l2_paid_ticket_diamond.address)
    admin_facet = interface.IL2PaidTicketAdmin(deployed_l2_paid_ticket_diamond.address)
    view_facet = interface.IL2PaidTicketView(deployed_l2_paid_ticket_diamond.address)

    return access_control, base_facet, admin_facet, view_facet


