import time

from brownie import reverts, chain


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
    staking.stake(id, 0, from_address)


def test_founders_key_staking_constructor(deployed_founders_key_staking):
    staking, soulbound, erc721a = deployed_founders_key_staking
    assert staking.FoundersKeyAddress() == erc721a.address
    assert staking.SoulboundFoundersKeyAddress() == soulbound.address


def test_founders_key_staking_stake(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, soulbound, erc721a = deployed_founders_key_staking
    curent_time = time.time()

    _mint_and_stake(staking, erc721a, from_admin, from_address, address, 1)

    assert soulbound.ownerOf(1) == address.address
    assert erc721a.ownerOf(1) == staking.address
    assert staking.stakedNFTIds(address.address, 0) == 1
    info = staking.userStakeInfo(address.address, 0)
    assert info[0] == 1
    assert info[1] >= curent_time
    assert info[2] == 0


def test_founders_key_staking_stake_multiple_times_same_nft(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, soulbound, erc721a = deployed_founders_key_staking
    curent_time = time.time()
    _mint_and_stake(staking, erc721a, from_admin, from_address, address, 1)
    chain.sleep(60 * 60 * 24 * 31)
    staking.unstake(1, from_address)
    _mint_and_stake(staking, erc721a, from_admin, from_address, address, 1)
    assert soulbound.ownerOf(1) == address.address
    assert erc721a.ownerOf(1) == staking.address
    assert staking.stakedNFTIds(address.address, 0) == 0
    assert staking.stakedNFTIds(address.address, 1) == 1
    info = staking.userStakeInfo(address.address, 0)
    assert info[0] == 0
    assert info[1] == 0
    assert info[2] == 0
    info = staking.userStakeInfo(address.address, 1)
    assert info[0] == 1
    assert info[1] >= curent_time
    assert info[2] == 0


def test_founders_key_staking_stake_no_owner(
    deployed_founders_key_staking,
    from_admin,
    admin,
    from_address,
):
    staking, _, erc721a = deployed_founders_key_staking
    erc721a.mint(admin.address, 1, from_admin)
    erc721a.approve(staking.address, 1, from_admin)
    with reverts():
        staking.stake(1, 0, from_address)


def test_founders_key_staking_stake_id_does_not_exist(
    deployed_founders_key_staking,
    from_admin,
):
    staking, _, _ = deployed_founders_key_staking
    with reverts():
        staking.stake(1, 0, from_admin)


def test_founders_key_staking_stake_id_already_staked(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, _, erc721a = deployed_founders_key_staking
    _mint_and_stake(staking, erc721a, from_admin, from_address, address, 1)
    with reverts():
        staking.stake(1, 0, from_address)


def test_founders_key_staking_stake_id_already_staked_by_other(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, _, erc721a = deployed_founders_key_staking
    _mint_and_stake(staking, erc721a, from_admin, from_address, address, 1)
    with reverts():
        staking.stake(1, 0, from_admin)


def test_founders_key_staking_stake_id_not_approved(
    deployed_founders_key_staking, from_admin, address, from_address
):
    staking, _, erc721a = deployed_founders_key_staking
    erc721a.mint(address.address, 1, from_admin)
    with reverts():
        staking.stake(1, 0, from_address)


def test_unstake_after_lock(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, soulbound, erc721a = deployed_founders_key_staking
    _mint_and_stake(staking, erc721a, from_admin, from_address, address, 1)
    # rpc sleep for 1 month
    chain.sleep(60 * 60 * 24 * 31)
    staking.unstake(1, from_address)
    with reverts():
        assert soulbound.ownerOf(1) == address.address
    assert erc721a.ownerOf(1) == address.address
    assert staking.stakedNFTIds(address.address, 0) == 0


def test_unstake_still_locked(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, _, erc721a = deployed_founders_key_staking
    _mint_and_stake(staking, erc721a, from_admin, from_address, address, 1)
    with reverts():
        staking.unstake(1, from_address)


def test_unstake_id_does_not_exist(
    deployed_founders_key_staking,
    from_address,
):
    staking, _, _ = deployed_founders_key_staking
    with reverts():
        staking.unstake(1, from_address)


def test_unstake_id_not_staked(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, _, erc721a = deployed_founders_key_staking
    erc721a.mint(address.address, 1, from_admin)
    with reverts():
        staking.unstake(1, from_address)


def test_unstake_id_not_staked_by_user(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, _, erc721a = deployed_founders_key_staking
    erc721a.mint(address.address, 1, from_admin)
    erc721a.approve(staking.address, 1, from_address)
    staking.stake(1, 0, from_address)
    with reverts():
        staking.unstake(1, from_admin)


def testSetFoundersKeyAddressNoAdmin(
    deployed_founders_key_staking,
    from_address,
    address,
):
    staking, _, _ = deployed_founders_key_staking
    with reverts():
        staking.setFoundersKeyAddress(address.address, from_address)


def testSetFoundersKeyAddress(
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    from_admin,
):
    staking, _, _ = deployed_founders_key_staking
    staking.setFoundersKeyAddress(deployed_erc721a_mock.address, from_admin)
    assert staking.FoundersKeyAddress() == deployed_erc721a_mock.address


def testSetSoulboundFoundersKeyAddressNoAdmin(
    deployed_founders_key_staking,
    from_address,
    address,
):
    staking, _, _ = deployed_founders_key_staking
    with reverts():
        staking.setSoulboundFoundersKeyAddress(address.address, from_address)


def testSetSoulboundFoundersKeyAddress(
    deployed_founders_key_staking,
    deployed_soulbound,
    from_admin,
):
    staking, _, _ = deployed_founders_key_staking
    staking.setSoulboundFoundersKeyAddress(deployed_soulbound[0].address, from_admin)
    assert staking.SoulboundFoundersKeyAddress() == deployed_soulbound[0].address


def testGetStakedInfo(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, _, erc721a = deployed_founders_key_staking
    erc721a.mint(address.address, 1, from_admin)
    erc721a.approve(staking.address, 1, from_address)
    staking.stake(1, 0, from_address)
    erc721a.mint(address.address, 2, from_admin)
    erc721a.approve(staking.address, 2, from_address)
    staking.stake(2, 1, from_address)

    info = staking.getStakedNFTInfos(address, from_address)

    assert info[0][0] == 1
    assert info[0][2] == 0
    assert info[1][0] == 2
    assert info[1][2] == 1


def test_get_staked_info_for_nft_id(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, _, erc721a = deployed_founders_key_staking
    erc721a.mint(address.address, 1, from_admin)
    erc721a.approve(staking.address, 1, from_address)
    staking.stake(1, 0, from_address)
    erc721a.mint(address.address, 2, from_admin)
    erc721a.approve(staking.address, 2, from_address)
    staking.stake(2, 1, from_address)

    info = staking.getStakedInfoForNFTId(address, 1, from_address)

    assert info[0] == 1
    assert info[2] == 0


def test_get_best_staked_nft_infos(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    import time

    current_time = time.time()
    staking, _, erc721a = deployed_founders_key_staking
    erc721a.mint(address.address, 1, from_admin)
    erc721a.approve(staking.address, 1, from_address)
    staking.stake(1, 0, from_address)
    erc721a.mint(address.address, 2, from_admin)
    erc721a.approve(staking.address, 2, from_address)
    staking.stake(2, 1, from_address)
    erc721a.mint(address.address, 3, from_admin)
    erc721a.approve(staking.address, 3, from_address)
    staking.stake(3, 1, from_address)

    best_type, amount, best_date = staking.getBestStakedNFTInfo(address, from_address)
    assert best_type == 4
    assert amount == 2
    assert best_date >= current_time
