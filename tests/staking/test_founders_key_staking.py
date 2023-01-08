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

def test_founders_key_staking_constructor(
    deployed_founders_key_staking
):
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

    _mint_and_stake(
        staking,
        erc721a,
        from_admin,
        from_address,
        address,
        1
    )

    assert soulbound.ownerOf(1) == address.address
    assert erc721a.ownerOf(1) == staking.address
    assert staking.stakedNFTIds(address.address, 0) == 1
    info = staking.userStakeInfo(address.address, 0) 
    assert info[0] == 1
    assert info[1] >= curent_time
    assert info[2] == 0
    assert info[3] == 0


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
    staking, _ , erc721a = deployed_founders_key_staking
    _mint_and_stake(
        staking,
        erc721a,
        from_admin,
        from_address,
        address,
        1
    )
    with reverts():
        staking.stake(1, 0, from_address)


def test_founders_key_staking_stake_id_already_staked_by_other(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, _ , erc721a = deployed_founders_key_staking
    _mint_and_stake(
        staking,
        erc721a,
        from_admin,
        from_address,
        address,
        1
    ) 
    with reverts():
        staking.stake(1, 0, from_admin)


def test_founders_key_staking_stake_id_not_approved(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address
):
    staking, _, erc721a = deployed_founders_key_staking
    erc721a.mint(address.address, 1, from_admin)
    with reverts():
        staking.stake(1, 0, from_address)


def test_unstake(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, soulbound, erc721a = deployed_founders_key_staking
    curent_time = time.time()
    _mint_and_stake(
        staking,
        erc721a,
        from_admin,
        from_address,
        address,
        1
    )
    # rpc sleep for 1 month
    chain.sleep(60 * 60 * 24 * 31)
    staking.unstake(1, from_address)
    with reverts():
        assert soulbound.ownerOf(1) == address.address
    assert erc721a.ownerOf(1) == address.address
    assert staking.stakedNFTIds(address.address, 0) == 0
    info = staking.userStakeInfo(address.address, 0) 
    assert info[2] >= curent_time


def test_unstake_still_locked(
    deployed_founders_key_staking,
    from_admin,
    address,
    from_address,
):
    staking, _, erc721a = deployed_founders_key_staking
    _mint_and_stake(
        staking,
        erc721a,
        from_admin,
        from_address,
        address,
        1
    )
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
