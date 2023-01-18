import brownie


def test_constructor(deployed_soulbound, deployed_erc721a_mock):
    assert deployed_soulbound.FoundersKeysAddress() == deployed_erc721a_mock.address


def test_safe_mint_not_owner_of_token(deployed_soulbound, address, from_admin):
    with brownie.reverts():
        deployed_soulbound.safeMint(address, 0, from_admin)


def test_safe_mint_success(
    deployed_soulbound, address, deployed_erc721a_mock, from_admin
):
    deployed_erc721a_mock.mint(address, 1, from_admin)
    deployed_soulbound.safeMint(address, 1, from_admin)
    assert deployed_soulbound.ownerOf(1) == deployed_erc721a_mock.ownerOf(1)
    assert deployed_soulbound.ownerOf(1) == address


def test_safe_mint_already_owned(
    deployed_soulbound, address, from_admin, deployed_erc721a_mock
):
    deployed_erc721a_mock.mint(address, 1, from_admin)
    deployed_soulbound.safeMint(address, 1, from_admin)
    with brownie.reverts():
        deployed_soulbound.safeMint(address, 1, from_admin)


def test_safe_mint_not_staking_contract_role(deployed_soulbound, from_address):
    with brownie.reverts():
        deployed_soulbound.safeMint(from_address["from"].address, 1, from_address)


def test_burn_not_staking_contract_role(
    deployed_soulbound, from_address, from_admin, deployed_erc721a_mock
):
    deployed_erc721a_mock.mint(from_address["from"].address, 1, from_admin)
    deployed_soulbound.safeMint(from_address["from"].address, 1, from_admin)
    with brownie.reverts():
        deployed_soulbound.burn(1, from_address)


def test_burn_success(deployed_soulbound, from_admin, deployed_erc721a_mock):
    deployed_erc721a_mock.mint(from_admin["from"].address, 1, from_admin)
    deployed_soulbound.safeMint(from_admin["from"].address, 1, from_admin)
    deployed_soulbound.burn(1, from_admin)
    with brownie.reverts():
        deployed_soulbound.ownerOf(1)


def test_soulbound_transfer(
    deployed_soulbound, address, from_admin, deployed_erc721a_mock
):
    deployed_erc721a_mock.mint(from_admin["from"].address, 1, from_admin)
    deployed_soulbound.safeMint(from_admin["from"].address, 1, from_admin)
    with brownie.reverts():
        deployed_soulbound.transferFrom(
            from_admin["from"].address, address, 1, from_admin
        )

    assert deployed_soulbound.ownerOf(1) == from_admin["from"].address


def test_token_uri(deployed_soulbound, from_admin, deployed_erc721a_mock):
    deployed_erc721a_mock.mint(from_admin["from"].address, 1, from_admin)
    deployed_soulbound.safeMint(from_admin["from"].address, 1, from_admin)
    assert deployed_soulbound.tokenURI(1) == "https://example.com"


def test_set_founders_key_address(deployed_soulbound, address, from_admin):
    deployed_soulbound.setFoundersKeysAddress(address, from_admin)
    assert deployed_soulbound.FoundersKeysAddress() == address


def test_set_founders_key_addresss_not_admin(deployed_soulbound, address, from_address):
    with brownie.reverts():
        deployed_soulbound.setFoundersKeysAddress(address, from_address)


def test_supports_interface(deployed_soulbound, from_admin):
    assert deployed_soulbound.supportsInterface("0x80ac58cd", from_admin)
    assert deployed_soulbound.supportsInterface("0x5b5e139f", from_admin)
    assert deployed_soulbound.supportsInterface("0x01ffc9a7", from_admin)

def test_cant_approve(deployed_soulbound, deployed_erc721a_mock, from_admin, address):
    deployed_erc721a_mock.mint(from_admin["from"].address, 1, from_admin)
    deployed_soulbound.safeMint(from_admin["from"].address, 1, from_admin)

    with brownie.reverts():
        deployed_soulbound.approve(address, 1, from_admin)

def test_cant_set_approval_for_all(deployed_soulbound, from_admin, address):
    with brownie.reverts():
        deployed_soulbound.setApprovalForAll(address, True, from_admin)
