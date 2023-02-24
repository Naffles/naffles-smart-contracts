import pytest
from brownie import L1NaffleAdmin, interface, L1NaffleView, L1NaffleBase

from scripts.util import get_selectors, add_facet
from tests.contracts.naffle.test_l1_naffle_diamond import \
    setup_diamond_with_facets


def test_admin_facet_deployment(
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_admin_facet,
):
    start_facet_number = len(deployed_l1_naffle_diamond.facets())

    add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_admin_facet,
        from_admin,
        get_selectors(L1NaffleAdmin)
    )

    assert len(deployed_l1_naffle_diamond.facets()) == start_facet_number + 1


def test_set_minimum_naffle_duration(
    admin,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    admin_facet.setAdmin(admin, from_admin)
    admin_facet.setMinimumNaffleDuration(1, from_admin)

    assert view_facet.getMinimumNaffleDuration() == 1
