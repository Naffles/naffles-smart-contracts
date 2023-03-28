from brownie import L1NaffleAdmin, L1NaffleBase, TestValueFacet

from scripts.util import (
    OWNABLE_SELECTORS,
    add_facet,
    get_error_message,
    get_name_by_selector,
    get_selector_by_name,
    get_selectors,
    remove_duplicated_selectors,
)


def test_get_selectors():
    selectors = get_selectors(TestValueFacet)

    assert len(selectors) == 2
    assert "0x20965255" in selectors
    assert "0x93a09352" in selectors


def test_get_selectors_remove_ownable():
    selectors = get_selectors(L1NaffleAdmin)
    for selector in OWNABLE_SELECTORS:
        assert selector not in selectors


def test_remove_supports_interface():
    selectors = get_selectors(L1NaffleBase)
    assert get_selector_by_name(L1NaffleBase, "supportsInterface") not in selectors


def test_get_name_by_selector():
    name = get_name_by_selector(TestValueFacet, "0x93a09352")

    assert name == "setValue"


def test_get_selector_by_name():
    selector = get_selector_by_name(TestValueFacet, "setValue")

    assert selector == "0x93a09352"


def test_remove_duplicated_selectors():
    current_selectors = ["0x93a09352", "0x20965255"]
    new_selectors = ["0x93a09352", "0x20965255", "0x12345678"]

    selectors = remove_duplicated_selectors(current_selectors, new_selectors)

    assert len(selectors) == 1
    assert "0x12345678" in selectors


def test_add_facet(
    deployed_l1_naffle_diamond, deployed_l1_naffle_base_facet, from_admin
):
    start_facet_number = len(deployed_l1_naffle_diamond.facets())

    add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        from_admin,
        get_selectors(L1NaffleBase),
    )

    assert len(deployed_l1_naffle_diamond.facets()) == start_facet_number + 1


def test_get_error_message():
    expected = "typed error: 0xfac2445f00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000002"
    assert get_error_message("Error", ["uint256", "uint256"], [1, 2]) == expected
