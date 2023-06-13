import datetime

import brownie
import pytest
from brownie import interface, chain

from scripts.util import get_error_message
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import (
    setup_l2_naffle_diamond_with_facets,
)
from tests.test_helper import (
    NAFFLE_ID,
    NFT_ID,
    PAID_TICKET_SPOTS,
    ERC721,
    STANDARD_NAFFLE_TYPE,
    TICKET_PRICE,
    create_naffle_and_mint_tickets, UNLIMITED_NAFFLE_TYPE, get_end_time,
)


def setup_l2_naffle_contract(
    admin_facet,
    l1_naffle_contract,
    paid_ticket_contract,
    open_entry_ticket_contract,
    l1_messenger_contract,
    from_admin,
):
    admin_facet.setL1NaffleContractAddress(l1_naffle_contract.address, from_admin)
    admin_facet.setPaidTicketContractAddress(paid_ticket_contract.address, from_admin)
    admin_facet.setL1MessengerContractAddress(l1_messenger_contract.address, from_admin)
    admin_facet.setOpenEntryTicketContractAddress(
        open_entry_ticket_contract.address, from_admin
    )


def test_create_naffle_not_allowed(
    address,
    from_address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
    deployed_l1_messenger_mock
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
        admin_facet,
        from_admin["from"],
        from_admin["from"],
        from_admin["from"],
        deployed_l1_messenger_mock,
        from_admin,
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
                get_end_time(),
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
    deployed_eth_zksync_mock,
    deployed_l1_messenger_mock,
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
        admin_facet,
        from_admin["from"],
        from_admin["from"],
        from_admin["from"],
        deployed_l1_messenger_mock,
        from_admin,
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
    expected_open_entry_ticket_spots = 0
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
        expected_open_entry_ticket_spots,
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
    deployed_l1_messenger_mock,
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
        admin_facet,
        from_admin["from"],
        deployed_erc721a_mock,
        from_admin["from"],
        deployed_l1_messenger_mock,
        from_admin,
    )

    with brownie.reverts(get_error_message("InvalidNaffleId", ["uint256"], [1])):
        base_facet.buyTickets(1, 1, {"from": admin, "value": 10})


def test_buy_tickets_invalid_naffle_status(
    admin,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
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
        admin_facet,
        from_admin["from"],
        deployed_erc721a_mock,
        from_admin["from"],
        deployed_l1_messenger_mock,
        from_admin,
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

    admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)
    with brownie.reverts(get_error_message("InvalidNaffleStatus", ["uint8"], [2])):
        base_facet.buyTickets(1, 1, {"from": admin, "value": 10})


def test_buy_tickets_not_enough_funds(
    admin,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
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
        admin_facet,
        from_admin["from"],
        deployed_erc721a_mock,
        from_admin["from"],
        deployed_l1_messenger_mock,
        from_admin,
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
    deployed_l1_messenger_mock,
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
        admin_facet,
        from_admin["from"],
        deployed_erc721a_mock,
        from_admin["from"],
        deployed_l1_messenger_mock,
        from_admin,
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
        base_facet.buyTickets(2, 1, {"from": admin, "value": TICKET_PRICE * 2})


def test_buy_tickets_does_mint_tickets_for_address(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )

    assert (
        interface.IERC721Base(
            l2_diamonds.deployed_l2_paid_ticket_diamond.address
        ).balanceOf(address, from_admin)
        == 2
    )


def test_buy_tickets_does_mint_tickets_for_address_unlimited(
    address, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        UNLIMITED_NAFFLE_TYPE,
        0,
    )

    assert (
        interface.IERC721Base(
            l2_diamonds.deployed_l2_paid_ticket_diamond.address
        ).balanceOf(address, from_admin)
        == 2
    )


def test_use_open_entry_tickets_invalid_naffle_id(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )

    with brownie.reverts(get_error_message("InvalidNaffleId", ["uint256"], [2])):
        l2_diamonds.naffle_base_facet.useOpenEntryTickets([1], 2, from_admin)


def test_use_open_entry_tickets_invalid_naffle_status(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )

    # SET NAFFLE STATUS TO COMPLETE
    return
    with brownie.reverts(get_error_message("InvalidNaffleStatus", ["uint8"], [2])):
        l2_diamonds.naffle_base_facet.useOpenEntryTickets([1], 2, from_admin)


def test_use_open_entry_tickets_not_enough_ticket_spots(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):

    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )

    print(get_error_message("NotEnoughOpenEntryTicketSpots", ["uint256"], [0]))
    with brownie.reverts(
        get_error_message("NotEnoughOpenEntryTicketSpots", ["uint256"], [0])
    ):
        l2_diamonds.naffle_base_facet.useOpenEntryTickets([1], 1, from_admin)


def test_use_open_entry_tickets_success(
    from_address,
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )

    l2_diamonds.naffle_base_facet.useOpenEntryTickets([1], 1, from_address)
    naffle = l2_diamonds.naffle_view_facet.getNaffleById(1, from_admin)

    # 7 is number of open entry tickets
    assert naffle[7] == 1


def test_owner_cancel_naffle_not_allowed(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )

    chain.sleep(100001)
    with brownie.reverts(get_error_message("NotAllowed")):
        l2_diamonds.naffle_base_facet.ownerCancelNaffle(1, from_admin)


def test_draw_winner_not_owner(
    admin,
    address,
    from_admin,
    from_address,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )
    chain.sleep(100001)
    with brownie.reverts(get_error_message("NotAllowed")):
        l2_diamonds.naffle_base_facet.ownerDrawWinner(NAFFLE_ID, from_admin)


def test_draw_winner_naffle_not_ended_yet(
    address,
    from_address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    end_time = get_end_time()
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
        end_time=end_time
    )

    naffle = l2_diamonds.naffle_view_facet.getNaffleById(1)

    with brownie.reverts(get_error_message("NaffleNotEndedYet", ["uint256"], [int(end_time)])):
        l2_diamonds.naffle_base_facet.drawWinner(NAFFLE_ID, from_admin)


def test_draw_winner_not_owner_sends_funds_to_owner(
    admin,
    address,
    from_admin,
    from_address,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )
    old_balance = address.balance()
    chain.sleep(100001)

    l2_diamonds.naffle_base_facet.drawWinner(NAFFLE_ID, from_admin)

    naffle = l2_diamonds.naffle_view_facet.getNaffleById(1)

    assert naffle[11] == 2  # paid ticket type
    assert naffle[12] == 4  # naffle status finished

    assert address.balance() == old_balance + (TICKET_PRICE * 2 * 0.99)



def test_owner_cancel_naffle_not_ended_yet(
    address,
    from_address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock
    )
    with brownie.reverts(get_error_message("NotAllowed")):
        l2_diamonds.naffle_base_facet.ownerCancelNaffle(NAFFLE_ID, from_admin)


def test_draw_winner(
    admin,
    from_address,
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )
    old_balance = address.balance()
    l2_diamonds.naffle_base_facet.drawWinner(1, from_address)

    naffle = l2_diamonds.naffle_view_facet.getNaffleById(1)

    # winning ticket id
    if naffle[11] != 1 and naffle[11] != 2:
        pytest.fail("Naffle winning ticket id is not 1 or 2")

    assert naffle[11] == 2  # paid ticket type
    assert naffle[12] == 4  # naffle status finished

    assert address.balance() == old_balance + (TICKET_PRICE * 2 * 0.99)


def test_owner_cancel_naffle_invalid_status(
    address,
    from_address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )
    l2_diamonds.naffle_admin_facet.adminCancelNaffle(1, from_admin)
    chain.sleep(100001)

    with brownie.reverts(get_error_message("InvalidNaffleStatus", ["uint8"], [2])):
        l2_diamonds.naffle_base_facet.ownerCancelNaffle(1, from_address)


def test_owner_cancel_naffle_invalid_type(
    address,
    from_address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        naffle_type=UNLIMITED_NAFFLE_TYPE,
    )
    l2_diamonds.naffle_admin_facet.adminCancelNaffle(1, from_admin)
    chain.sleep(100001)

    with brownie.reverts(get_error_message("InvalidNaffleType", ["uint8"], [1])):
        l2_diamonds.naffle_base_facet.ownerCancelNaffle(1, from_address)
