from scripts.util import get_selectors, get_selector_by_name

from brownie import TestValueFacet

def test_get_selectors():
    selectors = get_selectors(TestValueFacet)

    assert len(selectors) == 2
    assert selectors[0] == '0x20965255'
    assert selectors[1] == "0x93a09352"


def test_get_selector_by_name():
    selector = get_selector_by_name(TestValueFacet, 'setValue')

    assert selector == '0x93a09352'

