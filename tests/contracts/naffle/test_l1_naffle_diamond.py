from brownie import L1NaffleDiamond, L1NaffleBase, L1NaffleAdmin, L1NaffleView, accounts

def _add_facet(diamond, facet, from_admin, selectors):
    cut = [[facet.address, FacetCutAction.ADD.value, selectors]]
    diamond.diamondCut(cut, NULL_ADDRESS, b"", from_admin)

def test_facet_deployment(
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    start_facet_number = len(deployed_l1_naffle_diamond.facets())

    _add_facet(deployed_l1_naffle_diamond, deployed_l1_naffle_base_facet, from_admin, get_selectors(L1NaffleBase))
    _add_facet(deployed_l1_naffle_diamond, deployed_l1_naffle_admin_facet, from_admin, get_selectors(L1NaffleAdmin))
    _add_facet(deployed_l1_naffle_diamond, deployed_l1_naffle_view_facet, from_admin, get_selectors(L1NaffleView))

    assert len(deployed_l1_naffle_diamond.facets()) == start_facet_number + 3