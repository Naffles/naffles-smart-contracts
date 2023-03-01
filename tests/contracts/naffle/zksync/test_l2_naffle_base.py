import datetime

import brownie
from brownie import interface

from scripts.util import NULL_ADDRESS, ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import (
    setup_diamond_with_facets,
)



STANDARD_NAFFLE_TYPE = 0
UNLIMITED_NAFFLE_TYPE = 1

PLATFORM_FEE = 100
FREE_TICKET_RATIO = 100
NAFFLE_ID = 1

PAID_TICKET_SPOTS = 2
TICKET_PRICE = 10

ERC721 = 0
ERC1155 = 1

NFT_ID = 1


def setup_l2_naffle_contract(admin_facet, zksync_contract, paid_ticket_contract, from_admin):
    admin_facet.setPlatformFee(PLATFORM_FEE, from_admin)
    admin_facet.setFreeTicketRatio(FREE_TICKET_RATIO, from_admin)
    admin_facet.setL1NaffleContractAddress(zksync_contract.address, from_admin)
    admin_facet.setPaidTicketContractAddress(paid_ticket_contract.address, from_admin)


def test_create_naffle_not_allowed(
    address,
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
    setup_l2_naffle_contract(admin_facet, from_admin["from"], from_admin["from"], from_admin)

    with brownie.reverts(get_error_message("NotAllowed", [], [])):
        base_facet.createNaffle(
            (
                deployed_erc721a_mock.address,
                address,
                NAFFLE_ID,
                NFT_ID,
                PAID_TICKET_SPOTS,
                TICKET_PRICE,
                datetime.datetime.now().timestamp() + 1000,
                STANDARD_NAFFLE_TYPE,
                ERC721,
            ),
            from_address,
        )


def test_create_naffle(
    address,
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
    setup_l2_naffle_contract(admin_facet, from_admin["from"], from_admin["from"], from_admin)
    endtime = datetime.datetime.now().timestamp() + 1000

    base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            address,
            NAFFLE_ID,
            NFT_ID,
            PAID_TICKET_SPOTS,
            TICKET_PRICE,
            endtime,
            STANDARD_NAFFLE_TYPE,
            ERC721,
        ),
        from_admin,
    )

    naffle = view_facet.getNaffleById(NAFFLE_ID)
    expected_free_ticket_spots = 0
    expected_number_of_tickets_bought = 0
    expected_naffle_status = 0  # active
    expected_winning_ticket_type = 0  # none
    expected_winning_ticket_id = 0

    assert naffle == (
        deployed_erc721a_mock.address,
        address,
        NAFFLE_ID,
        NFT_ID,
        PAID_TICKET_SPOTS,
        expected_free_ticket_spots,
        expected_number_of_tickets_bought,
        expected_number_of_tickets_bought,
        TICKET_PRICE,
        endtime,
        expected_winning_ticket_id,
        expected_winning_ticket_type,
        expected_naffle_status,
        ERC721,
        STANDARD_NAFFLE_TYPE,
    )


def test_buy_tickets_invalid_naffle_id(
    admin,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_erc721a_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet
    )

    setup_l2_naffle_contract(admin_facet, from_admin["from"],
                             deployed_erc721a_mock, from_admin)

    with brownie.reverts(get_error_message("InvalidNaffleId", ['uint256'], [1])):
        base_facet.buyTickets(1, 1, {"from": admin, "value": 10})


def test_buy_tickets_invalid_naffle_status(
    admin,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_erc721a_mock,
):
    # can't test yet because no code available to set naffle status
    return
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet
    )

    setup_l2_naffle_contract(admin_facet, from_admin["from"],
                             deployed_erc721a_mock, from_admin)

    endtime = datetime.datetime.now().timestamp() + 1000
    base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            admin,
            NAFFLE_ID,
            NFT_ID,
            PAID_TICKET_SPOTS,
            TICKET_PRICE,
            endtime,
            STANDARD_NAFFLE_TYPE,
            ERC721,
        ),
        from_admin,
    )

    with brownie.reverts(
        get_error_message("InvalidNaffleStatus", ['uint8'], [0])
    ):
        base_facet.buyTickets(1, 1, {"from": admin, "value": 10})


def test_buy_tickets_not_enough_funds(
    admin,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_erc721a_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet
    )

    setup_l2_naffle_contract(admin_facet, from_admin["from"],
                             deployed_erc721a_mock, from_admin)

    endtime = datetime.datetime.now().timestamp() + 1000
    base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            admin,
            NAFFLE_ID,
            NFT_ID,
            PAID_TICKET_SPOTS,
            TICKET_PRICE,
            endtime,
            STANDARD_NAFFLE_TYPE,
            ERC721,
        ),
        from_admin,
    )

    with brownie.reverts(get_error_message("NotEnoughFunds", ['uint256'], [10])):
        base_facet.buyTickets(2, 1, {"from": admin, "value": 10})


def test_buy_tickets_not_enough_paid_ticket_spots(
    admin,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_erc721a_mock,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet
    )

    setup_l2_naffle_contract(admin_facet, from_admin["from"],
                             deployed_erc721a_mock, from_admin)

    endtime = datetime.datetime.now().timestamp() + 1000
    base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            admin,
            NAFFLE_ID,
            NFT_ID,
            1,
            TICKET_PRICE,
            endtime,
            STANDARD_NAFFLE_TYPE,
            ERC721,
        ),
        from_admin,
    )

    with brownie.reverts(get_error_message("NotEnoughPaidTicketSpots", ['uint256'], [1])):
        base_facet.buyTickets(2, 1, {"from": admin, "value": 20})


def test_buy_tickets_does_mint_tickets_for_address(
    admin,
    address,
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_view_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_base_facet,
    deployed_erc721a_mock
):
    from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_diamond import \
        setup_paid_ticket_diamond_with_facets
    from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_base import \
        setup_paid_ticket_contract

    naffle_access_control, naffle_base_facet, naffle_admin_facet, naffle_view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )

    paid_access_control, paid_base_facet, paid_admin_facet, paid_view_facet = setup_paid_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_paid_ticket_diamond,
        deployed_l2_paid_ticket_base_facet,
        deployed_l2_paid_ticket_admin_facet,
        deployed_l2_paid_ticket_view_facet,
    )

    setup_l2_naffle_contract(naffle_admin_facet, admin, deployed_l2_paid_ticket_diamond, from_admin)
    setup_paid_ticket_contract(paid_admin_facet, deployed_l2_naffle_diamond, from_admin)

    naffle_base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            address,
            NAFFLE_ID,
            NFT_ID,
            PAID_TICKET_SPOTS,
            TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            ERC721,
        ),
        from_admin,
    )

    naffle_base_facet.buyTickets(2, 1, {"from": address, "value": 20})


    assert interface.IERC721Base(deployed_l2_paid_ticket_diamond.address).balanceOf(address, from_admin) == 2

