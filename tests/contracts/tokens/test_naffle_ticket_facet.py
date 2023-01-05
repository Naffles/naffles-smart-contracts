import json

from brownie import NaffleTicketFacet, Contract 

from scripts.util import FacetCutAction, get_selectors
from tests.contracts.test_naffle_diamond import NULL_ADDRESS

def _create_diamond(
    diamond, 
    facet,
    from_admin
):
    cut = [[facet.address, FacetCutAction.Add.value, get_selectors(NaffleTicketFacet)]]
    diamond.diamondCut(cut, NULL_ADDRESS, b"", from_admin)


def _get_diamond_proxy(root_directory, diamond, filename="NaffleTicketFacet.json"):
    file = open(f"{root_directory}/build/contracts/{filename}")
    data = json.load(file)
    return Contract.from_abi("NaffleTicketFacet", data["abi"])

def test_naffle_ticket_facet_exists(
        deployed_naffle_diamond, 
        deployed_naffle_ticket_facet, 
        from_admin,
        root_directory):
    _create_diamond(deployed_naffle_diamond, 
                    deployed_naffle_ticket_facet, 
                    from_admin)

    diamond = _get_diamond_proxy(root_directory, deployed_naffle_diamond)
    assert diamond.exists(0) == False


def test_naffle_ticket_facet_token_uri(
    deployed_naffle_diamond, 
    deployed_naffle_ticket_facet, 
    from_admin,
    root_directory
):
    _create_diamond(deployed_naffle_diamond, 
                    deployed_naffle_ticket_facet, 
                    from_admin)

    diamond = _get_diamond_proxy(root_directory, deployed_naffle_diamond)
    diamond.setBaseURI("https://naffle.com/ticket")
    assert diamond.tokenURI(0) == "https://naffle.com/ticket"
    
