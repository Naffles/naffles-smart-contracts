from enum import Enum

from brownie import Contract

NULL_ADDRESS = "0x0000000000000000000000000000000000000000"

class FacetCutAction(Enum):
    ADD = 0
    REPLACE = 1
    REMOVE = 2


def get_selectors(contract):
    return list(contract.signatures.values())


def get_selector_by_name(contract, name):
    return contract.signatures[name]
