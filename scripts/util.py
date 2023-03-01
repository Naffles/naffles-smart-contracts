from enum import Enum
from typing import Any, Optional

from brownie import ZERO_ADDRESS
from Crypto.Hash import keccak
from eth_abi import encode

OWNABLE_SELECTORS = ["0x8ab5150a", "0x79ba5097", "0xf2fde38b", "0x8da5cb5b"]
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
    diamond.diamondCut(cut, ZERO_ADDRESS, b"", from_admin)


def remove_duplicated_selectors(current_selectors, new_selectors):
    return [selector for selector in new_selectors if selector not in current_selectors]


def get_error_message(
    error_name: str,
    types: [str] = [],
    values: list[Any] = [],
) -> str:
    error = f"{error_name}({', '.join(types)})"
    hash_ = keccak.new(
        data=error.encode("utf-8"),
        digest_bits=256,
    )
    encoded_abi = encode(types, values)
    result = f"typed error: 0x{hash_.digest()[:4].hex()}{encoded_abi.hex()}"
    print(result)
    return result
