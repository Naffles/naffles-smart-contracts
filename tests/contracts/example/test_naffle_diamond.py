from brownie import TestValueFacet, TestValueFacetUpgraded, interface

from scripts.util import (
    NULL_ADDRESS,
    FacetCutAction,
    get_selector_by_name,
    get_selectors,
)


def _add_facets(diamond, facet, from_admin):
    cut = [[facet.address, FacetCutAction.ADD.value, get_selectors(TestValueFacet)]]
    diamond.diamondCut(cut, NULL_ADDRESS, b"", from_admin)


def test_facet_deployment(
    from_admin,
    deployed_test_naffle_diamond,
    deployed_test_facet,
):
    start_facet_number = len(deployed_test_naffle_diamond.facets())

    _add_facets(deployed_test_naffle_diamond, deployed_test_facet, from_admin)

    assert len(deployed_test_naffle_diamond.facets()) == start_facet_number + 1


def test_set_and_get_value(
    from_admin, deployed_test_naffle_diamond, deployed_test_facet
):
    _add_facets(deployed_test_naffle_diamond, deployed_test_facet, from_admin)
    test_facet_proxy = interface.ITestValueFacet(deployed_test_naffle_diamond.address)
    test_facet_proxy.setValue("value", from_admin)
    assert test_facet_proxy.getValue() == "value"


def test_upgrade_storage_and_facet(
    from_admin,
    deployed_test_naffle_diamond,
    deployed_test_facet,
    deployed_test_facet_upgraded,
):
    _add_facets(deployed_test_naffle_diamond, deployed_test_facet, from_admin)
    test_facet_proxy = interface.ITestValueFacet(deployed_test_naffle_diamond.address)
    test_facet_proxy.setValue("value", from_admin)
    assert test_facet_proxy.getValue() == "value"

    upgrade_cut = [
        [
            deployed_test_facet_upgraded.address,
            FacetCutAction.REPLACE.value,
            [get_selector_by_name(TestValueFacet, "setValue")],
        ],
        [
            deployed_test_facet_upgraded.address,
            FacetCutAction.REPLACE.value,
            [get_selector_by_name(TestValueFacet, "getValue")],
        ],
        [
            deployed_test_facet_upgraded.address,
            FacetCutAction.ADD.value,
            [get_selector_by_name(TestValueFacetUpgraded, "getSecondValue")],
        ],
        [
            deployed_test_facet_upgraded.address,
            FacetCutAction.ADD.value,
            [get_selector_by_name(TestValueFacetUpgraded, "setSecondValue")],
        ],
    ]

    deployed_test_naffle_diamond.diamondCut(upgrade_cut, NULL_ADDRESS, b"", from_admin)
    test_facet_proxy = interface.ITestValueFacetUpgraded(
        deployed_test_naffle_diamond.address
    )

    assert test_facet_proxy.getValue() == "value"
    test_facet_proxy.setSecondValue("value2", from_admin)
    assert test_facet_proxy.getSecondValue() == "value2"

    test_facet_proxy.setValue("value3", from_admin)
    assert test_facet_proxy.getValue() == "value3"
