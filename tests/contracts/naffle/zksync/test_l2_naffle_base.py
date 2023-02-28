import datetime

import brownie

from scripts.util import NULL_ADDRESS, ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import setup_diamond_with_facets

STANDARD_NAFFLE_TYPE = 0
UNLIMITED_NAFFLE_TYPE = 1

PLATFORM_FEE = 100
FREE_TICKET_RATIO = 100


def _setup_contract(admin_facet, zksync_contract, from_admin):
    admin_facet.setPlatformFee(PLATFORM_FEE, from_admin)
    admin_facet.setFreeTicketRatio(FREE_TICKET_RATIO, from_admin)
    admin_facet.setZkSyncAddress(zksync_contract.address, from_admin)


def test_create_naffle_not_allowed(
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    _setup_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )

    nft_id = 1

    with brownie.reverts(get_error_message("NotAllowed", [], [])):
        base_facet.createNaffle(
            deployed_founders_key_staking.address,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            from_address,
        )


def test_create_naffle_invalid_end_time(
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    _setup_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    nft_id = 1
    end_time = int(datetime.datetime.now().timestamp()) + 1

    with brownie.reverts(get_error_message("InvalidEndTime", ["uint256"], [end_time])):
        base_facet.createNaffle(
            deployed_erc721a_mock.address,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            end_time,
            STANDARD_NAFFLE_TYPE,
            from_address,
        )


def test_create_naffle_invalid_minimum_paid_ticket_spots(
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    _setup_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    nft_id = 1
    minimum_paid_ticket_spots = MINIMUM_PAID_TICKET_SPOTS - 1

    with brownie.reverts(
        get_error_message(
            "InvalidPaidTicketSpots",
            ["uint256"],
            [minimum_paid_ticket_spots],
        )
    ):
        base_facet.createNaffle(
            deployed_erc721a_mock.address,
            nft_id,
            minimum_paid_ticket_spots,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 10000,
            STANDARD_NAFFLE_TYPE,
            from_address,
        )


def test_create_naffle_invalid_minimum_paid_ticket_spots_unlimited_type(
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    _setup_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    nft_id = 1

    with brownie.reverts(
        get_error_message(
            "InvalidPaidTicketSpots",
            ["uint256"],
            [MINIMUM_PAID_TICKET_SPOTS],
        )
    ):
        base_facet.createNaffle(
            deployed_erc721a_mock.address,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 10000,
            UNLIMITED_NAFFLE_TYPE,
            from_address,
        )


def test_create_naffle_invalid_token_type(
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    _setup_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    nft_id = 1

    with brownie.reverts(""):
        base_facet.createNaffle(
            NULL_ADDRESS,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            from_address,
        )


def test_create_naffle_no_approval(
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    _setup_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)

    nft_id = 1

    with brownie.reverts(
        get_error_message("TransferCallerNotOwnerNorApproved", [], [])
    ):
        base_facet.createNaffle(
            deployed_erc721a_mock.address,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            from_address,
        )


def test_create_naffle_zksync_called(
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    _setup_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    deployed_erc721a_mock.setApprovalForAll(
        deployed_l2_naffle_diamond.address, True, from_address
    )
    nft_id = 1

    base_facet.createNaffle(
        deployed_erc721a_mock.address,
        nft_id,
        MINIMUM_PAID_TICKET_SPOTS,
        MINIMUM_TICKET_PRICE,
        datetime.datetime.now().timestamp() + 1000,
        STANDARD_NAFFLE_TYPE,
        from_address,
    )
    assert deployed_eth_zksync_mock.called()
