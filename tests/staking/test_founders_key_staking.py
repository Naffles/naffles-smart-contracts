import time

from brownie import reverts, chain

TOKEN_ID_ONE = 1
TOKEN_ID_TWO = 2
TOKEN_ID_THREE = 3

STAKING_DURATION_ONE_MONTH = 0
STAKING_DURATION_THREE_MONTHS = 1

THIRTYONE_DAYS_IN_SECONDS = 2678400


def _mint_and_stake(
    staking,
    erc721a,
    from_admin,
    from_address,
    address,
    id,
):
    erc721a.mint(address.address, id, from_admin)
    erc721a.approve(staking.address, id, from_address)
    staking.stake(id, STAKING_DURATION_ONE_MONTH, from_address)


def test_founders_key_staking_constructor(
    deployed_founders_key_staking, deployed_soulbound, deployed_erc721a_mock
):
    assert (
        deployed_founders_key_staking.FoundersKeyAddress()
        == deployed_erc721a_mock.address
    )
    assert (
        deployed_founders_key_staking.SoulboundFoundersKeyAddress()
        == deployed_soulbound.address
    )


def test_founders_key_staking_stake(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_soulbound,
    deployed_erc721a_mock,
):
    curent_time = time.time()

    _mint_and_stake(
        deployed_founders_key_staking,
        deployed_erc721a_mock,
        from_admin,
        from_address,
        address,
        TOKEN_ID_ONE,
    )

    assert deployed_soulbound.ownerOf(TOKEN_ID_ONE) == address.address
    assert (
        deployed_erc721a_mock.ownerOf(TOKEN_ID_ONE)
        == deployed_founders_key_staking.address
    )
    info = deployed_founders_key_staking.userStakeInfo(address.address, 0)
    assert info[0] == TOKEN_ID_ONE
    assert info[1] >= curent_time
    assert info[2] == STAKING_DURATION_ONE_MONTH


def test_founders_key_staking_stake_multiple_times_same_nft(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_soulbound,
    deployed_erc721a_mock,
):
    curent_time = time.time()
    _mint_and_stake(
        deployed_founders_key_staking,
        deployed_erc721a_mock,
        from_admin,
        from_address,
        address,
        TOKEN_ID_ONE,
    )
    chain.sleep(THIRTYONE_DAYS_IN_SECONDS)
    deployed_founders_key_staking.unstake(TOKEN_ID_ONE, from_address)
    _mint_and_stake(
        deployed_founders_key_staking,
        deployed_erc721a_mock,
        from_admin,
        from_address,
        address,
        TOKEN_ID_ONE,
    )
    assert deployed_soulbound.ownerOf(TOKEN_ID_ONE) == address.address
    assert deployed_erc721a_mock.ownerOf(1) == deployed_founders_key_staking.address
    info = deployed_founders_key_staking.userStakeInfo(address.address, 0)
    assert info[0] == 0
    assert info[1] == 0
    assert info[2] == 0
    info = deployed_founders_key_staking.userStakeInfo(address.address, 1)
    assert info[0] == TOKEN_ID_ONE
    assert info[1] >= curent_time
    assert info[2] == STAKING_DURATION_ONE_MONTH


def test_founders_key_staking_stake_no_owner(
    from_admin,
    admin,
    from_address,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    deployed_erc721a_mock.mint(admin.address, TOKEN_ID_ONE, from_admin)
    deployed_erc721a_mock.approve(
        deployed_founders_key_staking.address, TOKEN_ID_ONE, from_admin
    )
    with reverts():
        deployed_founders_key_staking.stake(
            TOKEN_ID_ONE, STAKING_DURATION_ONE_MONTH, from_address
        )


def test_founders_key_staking_stake_id_does_not_exist(
    from_admin,
    deployed_founders_key_staking
):
    with reverts():
        deployed_founders_key_staking.stake(
            TOKEN_ID_ONE, STAKING_DURATION_ONE_MONTH, from_admin
        )


def test_founders_key_staking_stake_id_already_staked(
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    from_admin,
    address,
    from_address,
):
    _mint_and_stake(
        deployed_founders_key_staking,
        deployed_erc721a_mock,
        from_admin,
        from_address,
        address,
        TOKEN_ID_ONE,
    )
    with reverts():
        deployed_founders_key_staking.stake(
            TOKEN_ID_ONE, STAKING_DURATION_ONE_MONTH, from_address
        )


def test_founders_key_staking_stake_id_already_staked_by_other(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    _mint_and_stake(
        deployed_founders_key_staking,
        deployed_erc721a_mock,
        from_admin,
        from_address,
        address,
        TOKEN_ID_ONE,
    )
    with reverts():
        deployed_founders_key_staking.stake(
            TOKEN_ID_ONE, STAKING_DURATION_ONE_MONTH, from_admin
        )


def test_founders_key_staking_stake_id_not_approved(
        from_admin, address, from_address, deployed_founders_key_staking, deployed_erc721a_mock):
    deployed_erc721a_mock.mint(address.address, TOKEN_ID_ONE, from_admin)
    with reverts():
        deployed_founders_key_staking.stake(
            TOKEN_ID_ONE, STAKING_DURATION_ONE_MONTH, from_address
        )


def test_unstake_after_lock(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_soulbound,
    deployed_erc721a_mock,
):
    _mint_and_stake(
        deployed_founders_key_staking,
        deployed_erc721a_mock,
        from_admin,
        from_address,
        address,
        TOKEN_ID_ONE,
    )
    chain.sleep(THIRTYONE_DAYS_IN_SECONDS)
    deployed_founders_key_staking.unstake(TOKEN_ID_ONE, from_address)
    with reverts():
        assert deployed_soulbound.ownerOf(TOKEN_ID_ONE) == address.address
    assert deployed_erc721a_mock.ownerOf(TOKEN_ID_ONE) == address.address
    assert deployed_founders_key_staking.userStakeInfo(address.address, 0)[0] == 0


def test_unstake_still_locked(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    _mint_and_stake(
        deployed_founders_key_staking,
        deployed_erc721a_mock,
        from_admin,
        from_address,
        address,
        TOKEN_ID_ONE,
    )
    with reverts():
        deployed_founders_key_staking.unstake(TOKEN_ID_ONE, from_address)


def test_unstake_id_does_not_exist(
    from_address,
    deployed_founders_key_staking,
):
    with reverts():
        deployed_founders_key_staking.unstake(TOKEN_ID_ONE, from_address)


def test_unstake_id_not_staked(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    deployed_erc721a_mock.mint(address.address, TOKEN_ID_ONE, from_admin)
    with reverts():
        deployed_founders_key_staking.unstake(TOKEN_ID_ONE, from_address)


def test_unstake_id_not_staked_by_user(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    deployed_erc721a_mock.mint(address.address, TOKEN_ID_ONE, from_admin)
    deployed_erc721a_mock.approve(
        deployed_founders_key_staking.address, TOKEN_ID_ONE, from_address
    )
    deployed_founders_key_staking.stake(
        TOKEN_ID_ONE, STAKING_DURATION_ONE_MONTH, from_address
    )
    with reverts():
        deployed_founders_key_staking.unstake(TOKEN_ID_ONE, from_admin)


def test_set_founders_key_address_no_admin(
    from_address,
    address,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    with reverts():
        deployed_founders_key_staking.setFoundersKeyAddress(
            address.address, from_address
        )


def test_set_founders_key_address(
    from_admin,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    deployed_founders_key_staking.setFoundersKeyAddress(
        deployed_erc721a_mock.address, from_admin
    )
    assert (
        deployed_founders_key_staking.FoundersKeyAddress()
        == deployed_erc721a_mock.address
    )


def test_set_soulbound_founders_key_address_no_admin(
    from_address,
    address,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    with reverts():
        deployed_founders_key_staking.setSoulboundFoundersKeyAddress(
            address.address, from_address
        )


def test_set_soulbound_founders_key_address(
    from_admin,
    deployed_founders_key_staking,
    deployed_soulbound,
    deployed_erc721a_mock,
):
    deployed_founders_key_staking.setSoulboundFoundersKeyAddress(
        deployed_soulbound.address, from_admin
    )
    assert (
        deployed_founders_key_staking.SoulboundFoundersKeyAddress()
        == deployed_soulbound.address
    )


def test_get_staked_info(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_soulbound,
    deployed_erc721a_mock,
):
    deployed_erc721a_mock.mint(address.address, TOKEN_ID_ONE, from_admin)
    deployed_erc721a_mock.approve(deployed_founders_key_staking.address, TOKEN_ID_ONE, from_address)
    deployed_founders_key_staking.stake(
        TOKEN_ID_ONE, STAKING_DURATION_ONE_MONTH, from_address
    )
    deployed_erc721a_mock.mint(address.address, TOKEN_ID_TWO, from_admin)
    deployed_erc721a_mock.approve(deployed_founders_key_staking.address, TOKEN_ID_TWO, from_address)
    deployed_founders_key_staking.stake(
        TOKEN_ID_TWO, STAKING_DURATION_THREE_MONTHS, from_address
    )

    info = deployed_founders_key_staking.getStakedNFTInfos(address, from_address)

    assert info[0][0] == TOKEN_ID_ONE
    assert info[0][2] == STAKING_DURATION_ONE_MONTH
    assert info[1][0] == TOKEN_ID_TWO
    assert info[1][2] == STAKING_DURATION_THREE_MONTHS


def test_get_staked_info_for_nft_id(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    deployed_erc721a_mock.mint(address.address, TOKEN_ID_ONE, from_admin)
    deployed_erc721a_mock.approve(
        deployed_founders_key_staking.address, TOKEN_ID_ONE, from_address
    )
    deployed_founders_key_staking.stake(
        TOKEN_ID_ONE, STAKING_DURATION_ONE_MONTH, from_address
    )
    deployed_erc721a_mock.mint(address.address, TOKEN_ID_TWO, from_admin)
    deployed_erc721a_mock.approve(
        deployed_founders_key_staking.address, TOKEN_ID_TWO, from_address
    )
    deployed_founders_key_staking.stake(
        TOKEN_ID_TWO, STAKING_DURATION_THREE_MONTHS, from_address
    )

    info = deployed_founders_key_staking.getStakedInfoForNFTId(
        address, TOKEN_ID_ONE, from_address
    )

    assert info[0] == TOKEN_ID_ONE
    assert info[2] == STAKING_DURATION_ONE_MONTH


def test_get_best_staked_nft_infos(
    from_admin,
    address,
    from_address,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
):
    current_time = time.time()
    deployed_erc721a_mock.mint(address.address, TOKEN_ID_ONE, from_admin)
    deployed_erc721a_mock.setApprovalForAll(
        deployed_founders_key_staking.address, True, from_address
    )
    deployed_founders_key_staking.stake(
        TOKEN_ID_ONE, STAKING_DURATION_ONE_MONTH, from_address
    )
    chain.sleep(THIRTYONE_DAYS_IN_SECONDS)
    deployed_founders_key_staking.unstake(TOKEN_ID_ONE, from_address)

    deployed_erc721a_mock.mint(address.address, TOKEN_ID_TWO, from_admin)
    deployed_founders_key_staking.stake(
        TOKEN_ID_TWO, STAKING_DURATION_THREE_MONTHS, from_address
    )

    deployed_erc721a_mock.mint(address.address, TOKEN_ID_THREE, from_admin)
    deployed_founders_key_staking.stake(
        TOKEN_ID_THREE, STAKING_DURATION_ONE_MONTH, from_address
    )
    chain.sleep(THIRTYONE_DAYS_IN_SECONDS)
    deployed_founders_key_staking.unstake(TOKEN_ID_THREE, from_address)

    deployed_founders_key_staking.stake(
        TOKEN_ID_ONE, STAKING_DURATION_THREE_MONTHS, from_address
    )
    deployed_founders_key_staking.stake(
        TOKEN_ID_THREE, STAKING_DURATION_THREE_MONTHS, from_address
    )

    best_type, amount, best_date = deployed_founders_key_staking.getBestStakedNFTInfo(
        address, from_address
    )
    assert best_type == 4
    assert amount == 2
    assert best_date >= current_time
