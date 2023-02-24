from scripts.util import (
    FacetCutAction,
    get_selectors,
    NULL_ADDRESS, get_selector_by_name, get_name_by_selector,
    _remove_duplicated_selectors, _add_facet,
)

from brownie import (
    L1NaffleDiamond, L1NaffleBase, L1NaffleAdmin, L1NaffleView, accounts)


def test_facet_deployment(
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    start_facet_number = len(deployed_l1_naffle_diamond.facets())
    selectors = []

    base_selectors = get_selectors(L1NaffleBase)
    admin_selectors = get_selectors(L1NaffleAdmin)
    view_selectors = get_selectors(L1NaffleView)

    _add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        from_admin,
        get_selectors(L1NaffleBase)
    )
    _add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_admin_facet,
        from_admin,
        _remove_duplicated_selectors(base_selectors, admin_selectors)
    )
    _add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_view_facet,
        from_admin,
        _remove_duplicated_selectors(base_selectors + admin_selectors,
                                     view_selectors)
    )

    assert len(deployed_l1_naffle_diamond.facets()) == start_facet_number + 3
