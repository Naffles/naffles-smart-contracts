from brownie import (
    L2OpenEntryTicketDiamond,
    L2OpenEntryTicketBase,
    L2OpenEntryTicketAdmin,
    L2OpenEntryTicketView,
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
    deployed_l2_open_entry_diamond = L2OpenEntryTicketDiamond.deploy(
        {"from": account},
        publish_source=publish_source,
    )

    deployed_l2_open_entry_base_facet = L2OpenEntryTicketBase.deploy({"from": account}, publish_source=publish_source)
    deployed_l2_open_entry_admin_facet = L2OpenEntryTicketAdmin.deploy({"from": account}, publish_source=publish_source)
    deployed_l2_open_entry_view_facet = L2OpenEntryTicketView.deploy({"from": account}, publish_source=publish_source)

    base_selectors = get_selectors(L2OpenEntryTicketBase)
    admin_selectors = get_selectors(L2OpenEntryTicketAdmin)
    view_selectors = get_selectors(L2OpenEntryTicketView)

    add_facet(
        deployed_l2_open_entry_diamond,
        deployed_l2_open_entry_base_facet,
        from_account,
        base_selectors,
    )
    add_facet(
        deployed_l2_open_entry_diamond,
        deployed_l2_open_entry_admin_facet,
        from_account,
        remove_duplicated_selectors(base_selectors, admin_selectors),
    )
    add_facet(
        deployed_l2_open_entry_diamond,
        deployed_l2_open_entry_view_facet,
        from_account,
        remove_duplicated_selectors(base_selectors + admin_selectors, view_selectors),
    )

    access_control = interface.IAccessControl(deployed_l2_open_entry_diamond.address)
    base_facet = interface.IL2OpenEntryTicketBase(deployed_l2_open_entry_diamond.address)
    admin_facet = interface.IL2OpenEntryTicketAdmin(deployed_l2_open_entry_diamond.address)
    view_facet = interface.IL2OpenEntryTicketView(deployed_l2_open_entry_diamond.address)

    return access_control, base_facet, admin_facet, view_facet


