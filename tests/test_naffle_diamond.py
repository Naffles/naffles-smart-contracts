from scripts.util import FacetCutAction, getSelectors

from brownie import Contract, TestValueFacet


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
    assert 1 == 0


def test_set_and_get_value(
        from_admin, deployed_naffle_diamond, deployed_test_facet):
    _add_facets(deployed_naffle_diamond, deployed_test_facet, from_admin)

    deployed_test_facet.setValue("value", from_admin)
    assert deployed_test_facet.getValue() == "value"


def test_upgrade_storage_and_faucet(
    from_admin, deployed_naffle_diamond, 
    deployed_test_facet, deployed_test_facet_upgraded
):
    _add_facets(deployed_naffle_diamond, deployed_test_facet, from_admin)

    deployed_test_facet.setValue("value", from_admin)
    assert deployed_test_facet.getValue() == "value"

    upgrade_cut = [
        [
           facet.address,
           facetCutAction.REPLACE.value,
           # TODO get selector for the function i need to upgrade
        ]
    ]

    assert deployed_test_facet_upgraded.getValue() == "value"
    deployed_test_facet_upgraded.setSecondValue("value2", from_admin)
    assert deployed_test_facet_upgraded.getSecondValue() == "value2"

    assert deployed_test_facet.getValue() == "value"

    deployed_test_facet.setValue("value3", from_admin)
    assert deployed_test_facet.getValue() == "value3"

    assert deployed_test_facet_upgraded.getValue() == "value2"
