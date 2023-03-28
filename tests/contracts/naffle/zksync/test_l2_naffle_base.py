import datetime

import brownie
from brownie import interface

from scripts.util import get_error_message
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import (
    setup_l2_naffle_diamond_with_facets,
)
from tests.test_helper import (
    DEFAULT_END_DATE,
    ERC721,
    FREE_TICKET_RATIO,
    NAFFLE_ID,
    NFT_ID,
    PAID_TICKET_SPOTS,
    PLATFORM_FEE,
    STANDARD_NAFFLE_TYPE,
    TICKET_PRICE,
    UNLIMITED_NAFFLE_TYPE,
    create_naffle_and_mint_tickets,
)


def setup_l2_naffle_contract(
    admin_facet, l1_naffle_contract, paid_ticket_contract, from_admin
):
    admin_facet.setPlatformFee(PLATFORM_FEE, from_admin)
    admin_facet.setFreeTicketRatio(FREE_TICKET_RATIO, from_admin)
    admin_facet.setL1NaffleContractAddress(l1_naffle_contract.address, from_admin)
    admin_facet.setPaidTicketContractAddress(paid_ticket_contract.address, from_admin)


def test_create_naffle_not_allowed(
    address,
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_erc721a_mock,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_l2_naffle_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    setup_l2_naffle_contract(
        admin_facet, from_admin["from"], from_admin["from"], from_admin
    )

    with brownie.reverts(get_error_message("NotAllowed", [], [])):
        base_facet.createNaffle(
            (
                deployed_erc721a_mock.address,
                address,
                NAFFLE_ID,
                NFT_ID,
                PAID_TICKET_SPOTS,
                TICKET_PRICE,
                DEFAULT_END_DATE,
                STANDARD_NAFFLE_TYPE,
                ERC721,
            ),
            from_address,
        )


def test_create_naffle(
    address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_erc721a_mock,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_l2_naffle_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    setup_l2_naffle_contract(
        admin_facet, from_admin["from"], from_admin["from"], from_admin
    )
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
    expected_free_ticket_spots = 2
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
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_l2_naffle_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )

    setup_l2_naffle_contract(
        admin_facet, from_admin["from"], deployed_erc721a_mock, from_admin
    )

    with brownie.reverts(get_error_message("InvalidNaffleId", ["uint256"], [1])):
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
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_l2_naffle_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )

    setup_l2_naffle_contract(
        admin_facet, from_admin["from"], deployed_erc721a_mock, from_admin
    )

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

    with brownie.reverts(get_error_message("NotEnoughFunds", ["uint256"], [10])):
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
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_l2_naffle_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )

    setup_l2_naffle_contract(
        admin_facet, from_admin["from"], deployed_erc721a_mock, from_admin
    )

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

    with brownie.reverts(
        get_error_message("NotEnoughPaidTicketSpots", ["uint256"], [1])
    ):
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
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
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
        deployed_erc721a_mock,
    )

    assert (
        interface.IERC721Base(deployed_l2_paid_ticket_diamond.address).balanceOf(
            address, from_admin
        )
        == 2
    )


def test_buy_tickets_does_mint_tickets_for_address_unlimited(
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
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
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
        deployed_erc721a_mock,
        UNLIMITED_NAFFLE_TYPE,
        0,
    )

    assert (
        interface.IERC721Base(deployed_l2_paid_ticket_diamond.address).balanceOf(
            address, from_admin
        )
        == 2
    )
