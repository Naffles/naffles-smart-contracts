import time 


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

    erc721a.mint(address.address, 1, from_admin)
    erc721a.approve(staking.address, 1, from_address)
    staking.stake(1, 0, from_address)
    assert soulbound.ownerOf(1) == address.address
    assert erc721a.ownerOf(1) == staking.address
    assert staking.stakedNFTIds(address.address, 0) == 1
    info = staking.userStakeInfo(address.address, 0) 
    assert info[0] == 1
    assert info[1] >= curent_time
    assert info[2] == 0
    assert info[3] == 0
