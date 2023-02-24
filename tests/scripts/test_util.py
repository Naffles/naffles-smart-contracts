from brownie import TestValueFacet

from scripts.util import get_selectors, get_selector_by_name


def test_get_selectors():
    selectors = get_selectors(TestValueFacet)

    assert len(selectors) == 2
    assert "0x20965255" in selectors
    assert "0x93a09352" in selectors


def test_get_selector_by_name():
    selector = get_selector_by_name(TestValueFacet, "setValue")

    assert selector == "0x93a09352"
