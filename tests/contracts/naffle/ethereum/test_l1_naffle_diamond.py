from brownie import L1NaffleAdmin, L1NaffleBase, L1NaffleView, interface

from scripts.util import add_facet, get_selectors, remove_duplicated_selectors


def setup_diamond_with_facets(
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    base_selectors = get_selectors(L1NaffleBase)
    admin_selectors = get_selectors(L1NaffleAdmin)
    view_selectors = get_selectors(L1NaffleView)

    add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        from_admin,
        base_selectors,
    )
    add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_admin_facet,
        from_admin,
        remove_duplicated_selectors(base_selectors, admin_selectors),
    )
    add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_view_facet,
        from_admin,
        remove_duplicated_selectors(base_selectors + admin_selectors, view_selectors),
    )
    access_control = interface.IAccessControl(deployed_l1_naffle_diamond.address)
    base_facet = interface.IL1NaffleBase(deployed_l1_naffle_diamond.address)
    admin_facet = interface.IL1NaffleAdmin(deployed_l1_naffle_diamond.address)
    view_facet = interface.IL1NaffleView(deployed_l1_naffle_diamond.address)
    return access_control, base_facet, admin_facet, view_facet


def test_facet_deployment(
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    start_facet_number = len(deployed_l1_naffle_diamond.facets())

    setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )

    assert len(deployed_l1_naffle_diamond.facets()) == start_facet_number + 3
