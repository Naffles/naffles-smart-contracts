import brownie


def test_constructor(deployed_soulbound, admin):
    soulbound_founders_key, erc721a_mock = deployed_soulbound
    assert soulbound_founders_key.FoundersKeysAddress() == erc721a_mock.address
    assert soulbound_founders_key.hasRole(
        soulbound_founders_key.STAKING_CONTRACT_ROLE(), admin.address
    )


def test_safe_mint_not_owner_of_token(deployed_soulbound, address, from_admin):
    soulbound_founders_key, _ = deployed_soulbound
    with brownie.reverts():
        soulbound_founders_key.safeMint(address, 0, from_admin)


def test_safe_mint_success(deployed_soulbound, address, from_admin):
    soulbound_founders_key, erc721a_mock = deployed_soulbound
    erc721a_mock.mint(address, 1, from_admin)
    soulbound_founders_key.safeMint(address, 1, from_admin)
    assert soulbound_founders_key.ownerOf(1) == erc721a_mock.ownerOf(1)
    assert soulbound_founders_key.ownerOf(1) == address


def test_safe_mint_already_owned(deployed_soulbound, address, from_admin):
    soulbound_founders_key, erc721a_mock = deployed_soulbound
    erc721a_mock.mint(address, 1, from_admin)
    soulbound_founders_key.safeMint(address, 1, from_admin)
    with brownie.reverts():
        soulbound_founders_key.safeMint(address, 1, from_admin)


def test_safe_mint_not_staking_contract_role(deployed_soulbound, from_address):
    soulbound_founders_key, _ = deployed_soulbound
    with brownie.reverts():
        soulbound_founders_key.safeMint(from_address["from"].address, 1, from_address)


def test_burn_not_staking_contract_role(deployed_soulbound, from_address):
    soulbound_founders_key, _ = deployed_soulbound
    with brownie.reverts():
        soulbound_founders_key.burn(1, from_address)


def test_burn_success(deployed_soulbound, from_admin):
    soulbound_founders_key, erc721a_mock = deployed_soulbound
    erc721a_mock.mint(from_admin["from"].address, 1, from_admin)
    soulbound_founders_key.safeMint(from_admin["from"].address, 1, from_admin)
    soulbound_founders_key.burn(1, from_admin)
    with brownie.reverts():
        soulbound_founders_key.ownerOf(1)


def test_soulbound_transfer(deployed_soulbound, address, from_admin):
    soulbound_founders_key, erc721a_mock = deployed_soulbound
    erc721a_mock.mint(from_admin["from"].address, 1, from_admin)
    soulbound_founders_key.safeMint(from_admin["from"].address, 1, from_admin)
    with brownie.reverts():
        soulbound_founders_key.transferFrom(
            from_admin["from"].address, address, 1, from_admin
        )

    assert soulbound_founders_key.ownerOf(1) == from_admin["from"].address


def test_token_uri(deployed_soulbound, from_admin):
    soulbound_founders_key, erc721a_mock = deployed_soulbound
    erc721a_mock.mint(from_admin["from"].address, 1, from_admin)
    soulbound_founders_key.safeMint(from_admin["from"].address, 1, from_admin)
    assert soulbound_founders_key.tokenURI(1) == "https://example.com"


def test_set_founders_key_address(deployed_soulbound, address, from_admin):
    soulbound_founders_key, _ = deployed_soulbound
    soulbound_founders_key.setFoundersKeysAddress(address, from_admin)
    assert soulbound_founders_key.FoundersKeysAddress() == address


def test_set_founders_key_addresss_not_admin(deployed_soulbound, address, from_address):
    soulbound_founders_key, _ = deployed_soulbound
    with brownie.reverts():
        soulbound_founders_key.setFoundersKeysAddress(address, from_address)


def test_supports_interface(deployed_soulbound, from_admin):
    deployed_soulbound, _ = deployed_soulbound
    assert deployed_soulbound.supportsInterface("0x80ac58cd", from_admin) == True
    assert deployed_soulbound.supportsInterface("0x5b5e139f", from_admin) == True
    assert deployed_soulbound.supportsInterface("0x01ffc9a7", from_admin) == True
