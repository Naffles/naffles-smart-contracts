from scripts.util import FacetCutAction, getSelectors

from brownie import Contract, TestValueStorage, TestValueFacet


NULL_ADDRESS = "0x0000000000000000000000000000000000000000"


def _add_facets(diamond, facet, from_admin):
   cut = [
        [
            facet.address,
            FacetCutAction.ADD.value,
            getSelectors(TestValueFacet)
        ]
    ] 
   diamond.diamondCut(
        cut, 
        NULL_ADDRESS,
        b'',
        from_admin
    )

def test_faucet_deployment(
    from_admin,
    deployed_naffle_diamond,
    deployed_test_facet,
):
    start_facet_number = len(deployed_naffle_diamond.facets())

    _add_facets(deployed_naffle_diamond, deployed_test_facet, from_admin)
    
    assert len(deployed_naffle_diamond.facets()) == start_facet_number + 1


def test_set_and_get_value(from_admin, deployed_naffle_diamond, deployed_test_facet):
    _add_facets(deployed_naffle_diamond, deployed_test_facet, from_admin)

    deployed_test_facet.setValue("value", from_admin)
    assert deployed_test_facet.getValue() == "value"

