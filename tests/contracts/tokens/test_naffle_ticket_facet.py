import json

from brownie import NaffleTicketFacet, Contract 

from scripts.util import FacetCutAction, get_name_by_selector, get_selector_by_name, get_selectors, NULL_ADDRESS


def _create_diamond(
    diamond, 
    facet,
    from_admin
):
    selectors = get_selectors(facet)
    # already present in the diamond
    selectors.remove(get_selector_by_name(facet, "supportsInterface"))
    cut = [[facet.address, FacetCutAction.ADD.value, selectors]] 
    diamond.diamondCut(cut, NULL_ADDRESS, b"", from_admin)

def _get_diamond_proxy(root_directory, diamond, filename="NaffleTicketFacet.json"):
    file = open(f"{root_directory}/build/contracts/{filename}")
    data = json.load(file)
    return Contract.from_abi("NaffleTicketFacet", diamond.address, data["abi"])


def test_naffle_ticket_facet_exists(
        deployed_naffle_diamond, 
        deployed_naffle_ticket_facet, 
        from_admin,
        root_directory):
    facets = deployed_naffle_diamond.facets()[0][1]
    selectors = get_selectors(NaffleTicketFacet)
    for facet in facets:
        if facet in selectors:
            print(facet)
            print(get_name_by_selector(NaffleTicketFacet, facet))
    _create_diamond(deployed_naffle_diamond, 
                    deployed_naffle_ticket_facet, 
                    from_admin)

    diamond = _get_diamond_proxy(root_directory, deployed_naffle_diamond)
    assert diamond.exists(0) == False


def naffle_ticket_facet_token_uri(
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
    
