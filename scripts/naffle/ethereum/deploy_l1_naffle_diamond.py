from brownie import (
    L1NaffleDiamond,
    L1NaffleBase,
    L1NaffleAdmin,
    L1NaffleView,
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
    deployed_l1_naffle_diamond = L1NaffleDiamond.deploy(
        {"from": account},
        publish_source=publish_source,
    )

    deployed_l1_naffle_base_facet = L1NaffleBase.deploy({"from": account}, publish_source=publish_source)
    deployed_l1_naffle_admin_facet = L1NaffleAdmin.deploy({"from": account}, publish_source=publish_source)
    deployed_l1_naffle_view_facet = L1NaffleView.deploy({"from": account}, publish_source=publish_source)

    base_selectors = get_selectors(L1NaffleBase)
    admin_selectors = get_selectors(L1NaffleAdmin)
    view_selectors = get_selectors(L1NaffleView)

    add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        from_account,
        base_selectors,
    )
    add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_admin_facet,
        from_account,
        remove_duplicated_selectors(base_selectors, admin_selectors),
    )
    add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_view_facet,
        from_account,
        remove_duplicated_selectors(base_selectors + admin_selectors, view_selectors),
    )

    access_control = interface.IAccessControl(deployed_l1_naffle_diamond.address)
    base_facet = interface.IL1NaffleBase(deployed_l1_naffle_diamond.address)
    admin_facet = interface.IL1NaffleAdmin(deployed_l1_naffle_diamond.address)
    view_facet = interface.IL1NaffleView(deployed_l1_naffle_diamond.address)

    return access_control, base_facet, admin_facet, view_facet


