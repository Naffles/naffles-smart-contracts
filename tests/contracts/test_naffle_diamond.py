import json
from scripts.util import FacetCutAction, get_selectors, get_selector_by_name 

from brownie import Contract, TestValueFacet, TestValueFacetUpgraded


NULL_ADDRESS = "0x0000000000000000000000000000000000000000"


def _add_facets(diamond, facet, from_admin):
   cut = [
        [
            facet.address,
            FacetCutAction.ADD.value,
            get_selectors(TestValueFacet)
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


def test_set_and_get_value(
        from_admin, deployed_naffle_diamond, deployed_test_facet, root_directory):
    _add_facets(deployed_naffle_diamond, deployed_test_facet, from_admin)

    file = open(f"{root_directory}/build/contracts/TestValueFacet.json")
    abi = json.load(file)["abi"]
    test_facet_proxy = Contract.from_abi("TestValueFacet", deployed_naffle_diamond.address, abi)
    test_facet_proxy.setValue("value", from_admin)
    assert test_facet_proxy.getValue() == "value"


def test_upgrade_storage_and_faucet(
    from_admin, deployed_naffle_diamond, 
    deployed_test_facet, deployed_test_facet_upgraded, root_directory
):
    _add_facets(deployed_naffle_diamond, deployed_test_facet, from_admin)

    file = open(f"{root_directory}/build/contracts/TestValueFacet.json")
    abi = json.load(file)["abi"]
    test_facet_proxy = Contract.from_abi("TestValueFacet", deployed_naffle_diamond.address, abi)

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
        ]
    ]

    deployed_naffle_diamond.diamondCut(
        upgrade_cut, 
        NULL_ADDRESS,
        b'',
        from_admin
    )

    file = open(f"{root_directory}/build/contracts/TestValueFacetUpgraded.json")
    abi = json.load(file)["abi"]
    test_facet_proxy = Contract.from_abi("TestValueFacetUpgraded", deployed_naffle_diamond.address, abi)

    assert test_facet_proxy.getValue() == "value"
    test_facet_proxy.setSecondValue("value2", from_admin)
    assert test_facet_proxy.getSecondValue() == "value2"

    test_facet_proxy.setValue("value3", from_admin)
    assert test_facet_proxy.getValue() == "value3"
