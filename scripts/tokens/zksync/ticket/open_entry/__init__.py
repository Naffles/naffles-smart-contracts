from brownie import (
    L2NaffleDiamond,
    L2NaffleBase,
    L2NaffleAdmin,
    L2NaffleView,
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
    deployed_l2_naffle_diamond = L2NaffleDiamond.deploy(
        {"from": account},
        publish_source=publish_source,
    )

    deployed_l2_naffle_base_facet = L2NaffleBase.deploy({"from": account}, publish_source=publish_source)
    deployed_l2_naffle_admin_facet = L2NaffleAdmin.deploy({"from": account}, publish_source=publish_source)
    deployed_l2_naffle_view_facet = L2NaffleView.deploy({"from": account}, publish_source=publish_source)

    base_selectors = get_selectors(L2NaffleBase)
    admin_selectors = get_selectors(L2NaffleAdmin)
    view_selectors = get_selectors(L2NaffleView)

    add_facet(
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        from_account,
        base_selectors,
    )
    add_facet(
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_admin_facet,
        from_account,
        remove_duplicated_selectors(base_selectors, admin_selectors),
    )
    add_facet(
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_view_facet,
        from_account,
        remove_duplicated_selectors(base_selectors + admin_selectors, view_selectors),
    )

    access_control = interface.IAccessControl(deployed_l2_naffle_diamond.address)
    base_facet = interface.IL2NaffleBase(deployed_l2_naffle_diamond.address)
    admin_facet = interface.IL2NaffleAdmin(deployed_l2_naffle_diamond.address)
    view_facet = interface.IL2NaffleView(deployed_l2_naffle_diamond.address)

    return access_control, base_facet, admin_facet, view_facet


