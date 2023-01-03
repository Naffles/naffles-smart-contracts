from enum import Enum

from brownie import Contract

class FacetCutAction(Enum):
    ADD = 0
    REPLACE = 1
    REMOVE = 2


def getSelectors(contract):
    print(contract.signatures)
    print(contract.selectors)
    return list(contract.signatures.values())
