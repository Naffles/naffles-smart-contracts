from enum import Enum

class FacetCutAction(Enum):
    ADD = 0
    REPLACE = 1
    REMOVE = 2


def getSelectors(contract):
    return list(contract.signatures.values())
