from scripts.util import FacetCutAction, getSelectors

from brownie import Contract, TestValueStorage, TestValueFacet


NULL_ADDRESS = "0x0000000000000000000000000000000000000000"

def test_faucet_deployment(
    from_admin,
    deployed_naffle_diamond,
    deployed_test_facet,
    deployed_test_storage
):
    cut = [
        [
            deployed_test_facet.address,
            FacetCutAction.ADD.value,
            getSelectors(TestValueFacet)
        ]
    ]
        
    start_facet_number = len(deployed_naffle_diamond.facets())

    deployed_naffle_diamond.diamondCut(
        cut, 
        NULL_ADDRESS,
        b'',
        from_admin
    )
    
    assert len(deployed_naffle_diamond.facets()) == start_facet_number + 1
