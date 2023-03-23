import datetime

import brownie
from brownie import ZERO_ADDRESS
from web3 import Web3

from scripts.util import ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.ethereum.test_l1_naffle_diamond import (
    setup_diamond_with_facets,
)
from tests.test_helper import ERC721

STANDARD_NAFFLE_TYPE = 0
UNLIMITED_NAFFLE_TYPE = 1

MINIMUM_NAFFLE_DURATION = 10
MINIMUM_PAID_TICKET_SPOTS = 2
MINIMUM_TICKET_PRICE = 2


def setup_l1_naffle_contract(
    admin_facet, deployed_founders_key_staking, eth_zksync, from_admin
):
    admin_facet.setMinimumNaffleDuration(MINIMUM_NAFFLE_DURATION, from_admin)
    admin_facet.setMinimumPaidTicketSpots(MINIMUM_PAID_TICKET_SPOTS, from_admin)
    admin_facet.setMinimumPaidTicketPriceInWei(MINIMUM_TICKET_PRICE, from_admin)
    admin_facet.setZkSyncAddress(eth_zksync.address, from_admin)
    admin_facet.setZkSyncNaffleContractAddress(ZKSYNC_ADDRESS, from_admin)
    admin_facet.setFoundersKeyAddress(deployed_founders_key_staking.address, from_admin)
    admin_facet.setFoundersKeyPlaceholderAddress(
        deployed_founders_key_staking.address, from_admin
    )


def test_create_naffle_not_allowed(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
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
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
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
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
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
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
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
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    nft_id = 1

    with brownie.reverts(""):
        base_facet.createNaffle(
            ZERO_ADDRESS,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            from_address,
        )


def test_create_naffle_invalid_token_type(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    nft_id = 1

    with brownie.reverts(get_error_message("InvalidTokenType")):
        base_facet.createNaffle(
            base_facet.address,
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
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)

    nft_id = 1

    with brownie.reverts(get_error_message("TransferCallerNotOwnerNorApproved")):
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
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    deployed_erc721a_mock.setApprovalForAll(
        deployed_l1_naffle_diamond.address, True, from_address
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


def test_process_message_from_l2_send_nft_back(
    address,
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
    zksync_l1_message_account
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock, from_admin
    )
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    deployed_erc721a_mock.setApprovalForAll(
        deployed_l1_naffle_diamond.address, True, from_address
    )
    nft_id = 1

    base_facet.createNaffle(
        deployed_erc721a_mock.address,
        nft_id,
        MINIMUM_PAID_TICKET_SPOTS,
        MINIMUM_TICKET_PRICE,
        datetime.datetime.now().timestamp() + 100000,
        STANDARD_NAFFLE_TYPE,
        from_address,
    )

    _naffleId = 1

    _zkSyncAddress = zksync_l1_message_account.address
    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    from eth_abi import encode

    action = "cancel"
    one = 1

    encoded_data = encode(["string", "uint256"], [action, one])
    hex_string = encoded_data.hex()
    base_facet.consumeMessageFromL2(
        _zkSyncAddress,
        _l2BlockNumber,
        _index,
        _l2TxNumberInBlock,
        # cancel, 1
        encoded_data,
        _proof,
        {"from": _zkSyncAddress}
    )


    assert view_facet.getNaffleById(_naffleId, from_address) == (
        deployed_erc721a_mock.address,
        nft_id,
        _naffleId,
        address,
        ZERO_ADDRESS,
        False,
        True,
        ERC721,
    )


