import datetime

import brownie
import pytest
from brownie.exceptions import VirtualMachineError
import web3

from scripts.util import ZKSYNC_ADDRESS, get_error_message, NULL_ADDRESS
from tests.contracts.naffle.test_l1_naffle_diamond import \
    setup_diamond_with_facets

STANDARD_NAFFLE_TYPE = 0
UNLIMITED_NAFFLE_TYPE = 1

MINIMUM_NAFFLE_DURATION = 10
MINIMUM_PAID_TICKET_SPOTS = 2
MINIMUM_TICKET_PRICE = 2


def _setup_contract(admin_facet, deployed_founders_key_staking, from_admin):
    admin_facet.setMinimumNaffleDuration(MINIMUM_NAFFLE_DURATION, from_admin)
    admin_facet.setMinimumPaidTicketSpots(MINIMUM_PAID_TICKET_SPOTS, from_admin)
    admin_facet.setMinimumTicketPriceInWei(MINIMUM_TICKET_PRICE, from_admin)
    admin_facet.setZkSyncAddress(ZKSYNC_ADDRESS, from_admin)
    admin_facet.setZkSyncNaffleContractAddress(ZKSYNC_ADDRESS, from_admin)
    admin_facet.setFoundersKeyAddress(deployed_founders_key_staking.address, from_admin)
    admin_facet.setFoundersKeyPlaceholderAddress(deployed_founders_key_staking.address, from_admin)


def test_create_naffle_not_allowed(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    _setup_contract(admin_facet, deployed_erc721a_mock, from_admin)

    nft_id = 1

    with brownie.reverts(get_error_message("NotAllowed()")):
        base_facet.createNaffle(
            deployed_founders_key_staking.address,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            from_address
        )


def test_create_naffle_invalid_end_time(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    _setup_contract(admin_facet, deployed_erc721a_mock, from_admin)
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    nft_id = 1

    with brownie.reverts(get_error_message('InvalidEndTime(uint256)')):
        base_facet.createNaffle(
            deployed_erc721a_mock.address,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1,
            STANDARD_NAFFLE_TYPE,
            from_address)


def test_create_naffle_invalid_minimum_paid_ticket_spots(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    _setup_contract(admin_facet, deployed_erc721a_mock, from_admin)
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    nft_id = 1

    with brownie.reverts(get_error_message('InvalidMinimumPaidTicketSpots(uint256)')):
        base_facet.createNaffle(
            deployed_erc721a_mock.address,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS - 1,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            from_address)


def test_create_naffle_invalid_naffle_type(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    _setup_contract(admin_facet, deployed_erc721a_mock, from_admin)
    deployed_erc721a_mock.mint(from_address["from"], 1, from_admin)
    nft_id = 1

    with brownie.reverts(get_error_message('InvalidNaffleType(uint256)')):
        base_facet.createNaffle(
            NULL_ADDRESS,
            nft_id,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            2,
            from_address)


