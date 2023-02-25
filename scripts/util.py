from enum import Enum
from typing import Optional

from web3 import Web3

OWNABLE_SELECTORS = ["0x8ab5150a", "0x79ba5097", "0xf2fde38b", "0x8da5cb5b"]
NULL_ADDRESS = "0x0000000000000000000000000000000000000000"
BORED_APES_ADDRESS = "0x7Bd29408f11D2bFC23c34f18275bBf23bB716Bc7"
ZKSYNC_ADDRESS = "0xaBEA9132b05A70803a4E85094fD0e1800777fBEF"


class FacetCutAction(Enum):
    ADD = 0
    REPLACE = 1
    REMOVE = 2


def get_selectors(contract) -> list[str]:
    selectors = set(contract.signatures.values())
    try:
        selectors.remove(get_selector_by_name(contract, "supportsInterface"))
    except KeyError:
        pass
    for value in OWNABLE_SELECTORS:
        try:
            selectors.remove(value)
        except KeyError:
            pass
    return list(selectors)


def get_selector_by_name(contract, name) -> str:
    return contract.signatures[name]


def get_name_by_selector(contract, selector) -> Optional[str]:
    for key, selector_ in contract.signatures.items():
        if selector == selector_:
            return key


def add_facet(diamond, facet, from_admin, selectors) -> None:
    cut = [[facet.address, FacetCutAction.ADD.value, selectors]]
    diamond.diamondCut(cut, NULL_ADDRESS, b"", from_admin)


def remove_duplicated_selectors(current_selectors, new_selectors):
    return [selector for selector in new_selectors if selector not in current_selectors]


def get_error_message(error) -> str:
    return f"typed error: {Web3.keccak(text=f'{error}')[:4].hex()}"
