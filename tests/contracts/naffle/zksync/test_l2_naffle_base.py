import datetime

import brownie
import pytest
from brownie import interface, chain

from scripts.util import get_error_message
from tests.conftest import default_token_info
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import (
    setup_l2_naffle_diamond_with_facets,
)
from tests.test_helper import (
    ERC20,
    ERC721,
    OPEN_ENTRY_TICKET_RATIO,
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
    admin_facet.setMaxPostponeTime(86400, from_admin)


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
    deployed_l1_messenger_mock,
    default_token_info
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
                default_token_info,
                address,
                NAFFLE_ID,
                PAID_TICKET_SPOTS,
                TICKET_PRICE,
                get_end_time(),
                STANDARD_NAFFLE_TYPE,
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
    default_token_info,
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
            default_token_info,
            address,
            NAFFLE_ID,
            1000,
            TICKET_PRICE,
            endtime,
            STANDARD_NAFFLE_TYPE,
        ),
        from_admin,
    )

    naffle = view_facet.getNaffleById(NAFFLE_ID)
    expected_open_entry_ticket_spots = 10
    expected_number_of_tickets_bought = 0
    expected_naffle_status = 0  # active
    expected_winning_ticket_id = 0

    assert naffle == (
        (
            deployed_erc721a_mock.address,
            NFT_ID,
            1,
            ERC721
        ),
        address,
        NAFFLE_ID,
        1000,
        expected_open_entry_ticket_spots,
        expected_number_of_tickets_bought,
        expected_number_of_tickets_bought,
        TICKET_PRICE,
        endtime,
        expected_winning_ticket_id,
        expected_naffle_status,
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
    default_token_info,
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
            default_token_info,
            admin,
            NAFFLE_ID,
            PAID_TICKET_SPOTS,
            TICKET_PRICE,
            endtime,
            STANDARD_NAFFLE_TYPE,
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
    default_token_info,
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
            default_token_info,
            admin,
            NAFFLE_ID,
            PAID_TICKET_SPOTS,
            TICKET_PRICE,
            endtime,
            STANDARD_NAFFLE_TYPE,
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
    default_token_info,
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
            default_token_info,
            admin,
            NAFFLE_ID,
            1,
            TICKET_PRICE,
            endtime,
            STANDARD_NAFFLE_TYPE,
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
    default_token_info
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )

    assert (
        interface.IERC1155Base(
            l2_diamonds.deployed_l2_paid_ticket_diamond.address
        ).balanceOf(address, 1, from_admin)
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

    # 6 is number of open entry tickets
    assert naffle[6] == 1

def test_postpone_naffle_invalid_naffle_id(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )

    endtime = datetime.datetime.now().timestamp() + 1000
    with brownie.reverts(get_error_message("InvalidNaffleId", ["uint256"], [2])):
        l2_diamonds.naffle_base_facet.postponeNaffle(2, endtime, from_admin)


def test_postpone_naffle_invalid_naffle_type(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
    default_token_info,
):
    end_time = get_end_time()
    l2_diamonds.naffle_base_facet.createNaffle(
        (
            default_token_info,
            address,
            NFT_ID,
            100,
            TICKET_PRICE,
            end_time,
            1,  # UNLIMITED NAFFLE TYPE
        ),
        from_admin,
    )

    with brownie.reverts(get_error_message("InvalidNaffleType", ["uint8"], [1])):
        l2_diamonds.naffle_base_facet.postponeNaffle(1, end_time, from_admin)


def test_postpone_naffle_invalid_naffle_status(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )

    l2_diamonds.naffle_admin_facet.adminCancelNaffle(1, from_admin)
    end_time = get_end_time()
    with brownie.reverts(get_error_message("InvalidNaffleStatus", ["uint8"], [2])):
        l2_diamonds.naffle_base_facet.postponeNaffle(1, end_time, from_admin)


def test_postpone_naffle_not_finished(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
):
    end_time = get_end_time()
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        end_time=end_time
    )

    with brownie.reverts(get_error_message("NaffleNotFinished", ["uint256"], [int(end_time)])):
        l2_diamonds.naffle_base_facet.postponeNaffle(1, end_time, from_admin)


def test_postpone_naffle_not_owner(
    address,
    admin,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )
    chain.sleep(200000)
    with brownie.reverts(get_error_message("NotNaffleOwner", ["address"], [address.address])):
        l2_diamonds.naffle_base_facet.postponeNaffle(1, get_end_time(), from_admin)


def test_postpone_naffle_time_in_past(
    address,
    admin,
    from_address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
):
    end_time = get_end_time()
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        end_time=end_time
    )
    chain.sleep(100000)
    end_time = get_end_time() - 1000000
    with brownie.reverts(get_error_message("InvalidEndTime", ["uint256"], [int(end_time)])):
        l2_diamonds.naffle_base_facet.postponeNaffle(1, end_time, from_address)


def test_postpone_naffle_too_long(
    address,
    admin,
    from_address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )
    chain.sleep(100000)
    end_time = get_end_time() + 100000000000000
    with brownie.reverts(get_error_message("InvalidEndTime", ["uint256"], [int(end_time)])):
        l2_diamonds.naffle_base_facet.postponeNaffle(1, end_time, from_address)


def test_postpone_naffle_success(
    address,
    admin,
    from_address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    deployed_l1_messenger_mock,
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )
    chain.sleep(100000)
    end_time = chain.time() + 1000
    l2_diamonds.naffle_base_facet.postponeNaffle(1, end_time , from_address)
    naffle = l2_diamonds.naffle_view_facet.getNaffleById(1, from_admin)
    assert naffle[8] == end_time
    assert naffle[10] == 1  # postponed


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


def test_draw_winner_number_already_requested(
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

    with brownie.reverts(get_error_message("RandomNumberAlreadyRequested")):
        l2_diamonds.naffle_base_facet.drawWinner(NAFFLE_ID, from_admin)


def test_draw_winner_does_not_revert(
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
        number_of_tickets=100,
    )
    chain.sleep(100001)

    l2_diamonds.naffle_base_facet.drawWinner(NAFFLE_ID, from_admin)


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


def test_set_winner(
    admin,
    from_address,
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    platform_discount_params
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
    )
    old_balance = address.balance()
    l2_diamonds.naffle_base_facet.setWinner(1, 1, address, platform_discount_params, from_address)

    naffle = l2_diamonds.naffle_view_facet.getNaffleById(1)


    # winning ticket id
    if naffle[9] != 1 and naffle[9] != 2:
        pytest.fail("Naffle winning ticket id is not 1 or 2")

    assert naffle[10] == 4  # naffle status finished

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


def test_refund_tickets_invalid_naffle_id(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )

    with brownie.reverts(get_error_message("InvalidNaffleId", ["uint256"], [2])):
        l2_diamonds.naffle_admin_facet.adminCancelNaffle(2, from_admin)


def test_refund_tickets_success(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )

    old_balance = address.balance()

    l2_diamonds.naffle_base_facet.useOpenEntryTickets(
        [1], 1, from_address
    )

    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)

    l2_diamonds.naffle_base_facet.refundTicketsForNaffle(
        NAFFLE_ID, [1], address.address, from_address
    )

    assert address.balance() == old_balance + (TICKET_PRICE * 2)


def test_cancel_refund_and_create_refund(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock, default_token_info
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )
    l2_diamonds.open_entry_admin_facet.adminMint(address, 3, from_admin)

    l2_diamonds.naffle_base_facet.useOpenEntryTickets(
        [1, 2], 1, from_address
    )
    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)

    l2_diamonds.naffle_base_facet.refundTicketsForNaffle(
        NAFFLE_ID, [1, 2], address.address, from_address
    )

    l2_diamonds.naffle_base_facet.createNaffle(
        (
            default_token_info,
            address,
            NAFFLE_ID + 1,
            200,
            TICKET_PRICE,
            get_end_time(),
            0,
        ),
        from_admin,
    )

    l2_diamonds.naffle_base_facet.buyTickets(2, 2, {"from": address, "value": TICKET_PRICE * 2})

    l2_diamonds.naffle_base_facet.useOpenEntryTickets(
        [1, 2], 2, from_address
    )

    l2_diamonds.naffle_base_facet.refundTicketsForNaffle(
        NAFFLE_ID, [], address.address, from_address
    )

    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID + 1, from_admin)
    l2_diamonds.naffle_base_facet.refundTicketsForNaffle(
        NAFFLE_ID + 1, [1, 2], address.address, from_address)
