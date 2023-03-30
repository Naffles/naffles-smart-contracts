import datetime

import brownie
import pytest
from brownie import L2NaffleAdmin, chain

from scripts.util import add_facet, get_error_message, get_selectors
from tests.contracts.naffle.zksync.test_l2_naffle_base import (
    ERC721,
    STANDARD_NAFFLE_TYPE,
    setup_l2_naffle_contract,
)
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import (
    setup_l2_naffle_diamond_with_facets,
)
from tests.test_helper import (
    DEFAULT_END_DATE,
    NAFFLE_ID,
    NFT_ID,
    PAID_TICKET_SPOTS,
    TICKET_PRICE,
    create_naffle_and_mint_tickets,
)

TEST_ADDRESS = "0xb3D0248016434793037ED3abF8865d701f40AA82"


def test_admin_facet_deployment(
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_admin_facet,
):
    start_facet_number = len(deployed_l2_naffle_diamond.facets())

    add_facet(
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_admin_facet,
        from_admin,
        get_selectors(L2NaffleAdmin),
    )

    assert len(deployed_l2_naffle_diamond.facets()) == start_facet_number + 1


def test_get_and_set_platform_fee(
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    admin_facet.setPlatformFee(1, from_admin)

    assert view_facet.getPlatformFee() == 1


def test_set_platform_fee_not_admin(
    from_admin,
    from_address,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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

    with brownie.reverts():
        admin_facet.setPlatformFee(1, from_address)


def test_get_and_set_open_entry_ticket_ratio(
    admin,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    admin_facet.setOpenEntryRatio(1, from_admin)

    assert view_facet.getOpenEntryRatio() == 1


def test_set_free_ticket_ratio_cannot_be_zero(
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_l2_naffle_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    with brownie.reverts(get_error_message("OpenTicketRatioCannotBeZero")):
        admin_facet.setOpenEntryRatio(0, from_admin)


def test_set_open_entry_ticket_ratio_not_admin(
    from_admin,
    from_address,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    with brownie.reverts():
        admin_facet.setOpenEntryRatio(1, from_address)


def test_get_and_set_l1_naffle_contract_address(
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    admin_facet.setL1NaffleContractAddress(TEST_ADDRESS, from_admin)

    assert view_facet.getL1NaffleContractAddress() == TEST_ADDRESS


def test_set_zksync_address_not_admin(
    from_admin,
    from_address,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    with brownie.reverts():
        admin_facet.setL1NaffleContractAddress(TEST_ADDRESS, from_address)


def test_get_and_set_admin_address(
    address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    admin_facet.setAdmin(address, from_admin)

    assert access_control.hasRole(view_facet.getAdminRole(), address)


def test_set_admin_address_not_admin(
    address,
    from_admin,
    from_address,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    with brownie.reverts():
        admin_facet.setAdmin(address, from_address)


def test_get_naffle_by_id(
    admin,
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

    naffle = brownie.interface.IL2NaffleView(l2_diamonds.deployed_l2_naffle_diamond).getNaffleById(1)

    number_of_tickets_bought = 2
    number_of_open_entry_tickets = 0
    winning_ticket_id = 0
    winning_ticket_type = 0
    status = 0  # active
    token_type = ERC721  # ERC721

    assert naffle == (
        deployed_erc721a_mock.address,
        address,
        NAFFLE_ID,
        NFT_ID,
        PAID_TICKET_SPOTS,
        number_of_open_entry_tickets,
        number_of_tickets_bought,
        number_of_open_entry_tickets,
        TICKET_PRICE,
        DEFAULT_END_DATE,
        winning_ticket_id,
        winning_ticket_type,
        status,
        token_type,
        STANDARD_NAFFLE_TYPE,
    )


def test_get_and_set_paid_ticket_contract_address(
    address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    admin_facet.setPaidTicketContractAddress(address, from_admin)

    assert view_facet.getPaidTicketContractAddress() == address


def test_set_paid_ticket_contract_address_not_admin(
    address,
    from_admin,
    from_address,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    with brownie.reverts():
        admin_facet.setPaidTicketContractAddress(address, from_address)


def test_get_and_set_open_entry_ticket_contract_address(
    address,
    from_admin,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    admin_facet.setOpenEntryTicketContractAddress(address, from_admin)

    assert view_facet.getOpenEntryTicketContractAddress() == address


def test_set_open_entry_ticket_contract_address_not_admin(
    address,
    from_admin,
    from_address,
    deployed_l2_naffle_diamond,
    deployed_l2_naffle_base_facet,
    deployed_l2_naffle_admin_facet,
    deployed_l2_naffle_view_facet,
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
    with brownie.reverts():
        admin_facet.setOpenEntryTicketContractAddress(address, from_address)


def test_cancel_naffle(
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

    admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)
    assert view_facet.getNaffleById(NAFFLE_ID)[12] == 2  # cancelled
    assert deployed_l1_messenger_mock.called()


def test_cancel_naffle_invalid_naffle_id(
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

    with brownie.reverts(get_error_message("InvalidNaffleId", ['uint256'], [2])):
        admin_facet.adminCancelNaffle(2, from_admin)


def test_cancel_naffle_invalid_status(
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

    admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)
    with brownie.reverts(get_error_message("InvalidNaffleStatus", ['uint8'], [2])):
        admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)


def test_cancel_naffle_not_allowed(
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

    with brownie.reverts():
        admin_facet.adminCancelNaffle(NAFFLE_ID, from_address)


def test_draw_winner_not_admin(
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
    chain.sleep(1001)
    with brownie.reverts():
        l2_diamonds.naffle_admin_facet.adminDrawWinner(NAFFLE_ID, from_address)


def test_draw_winner_invalid_naffle_id(
    admin,
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
    chain.sleep(1001)
    with brownie.reverts(get_error_message("InvalidNaffleId", ['uint256'], [2])):
        l2_diamonds.naffle_admin_facet.adminDrawWinner(2, from_admin)


def test_draw_winner_invalid_naffle_status(
    admin,
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
    chain.sleep(1001)
    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)
    with brownie.reverts(get_error_message("InvalidNaffleStatus", ['uint8'], [2])):
        l2_diamonds.naffle_admin_facet.adminDrawWinner(1, from_admin)


def test_draw_winner_naffle_not_ended(
    admin,
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    l2_diamonds.naffle_base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            address,
            NAFFLE_ID,
            NFT_ID,
            100,
            TICKET_PRICE,
            DEFAULT_END_DATE + 10000,
            0,
            ERC721,
        ),
        from_admin,
    )
    with brownie.reverts(get_error_message("NaffleNotEndedYet", ['uint256'], [int(DEFAULT_END_DATE + 10000)])):
        l2_diamonds.naffle_admin_facet.adminDrawWinner(1, from_admin)


def test_draw_winner_no_tickets_bought(
    admin,
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
):
    l2_diamonds.naffle_base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            address,
            NAFFLE_ID,
            NFT_ID,
            100,
            TICKET_PRICE,
            DEFAULT_END_DATE,
            0,
            ERC721,
        ),
        from_admin,
    )
    chain.sleep(1001)
    with brownie.reverts(get_error_message("NoTicketsBought")):
        l2_diamonds.naffle_admin_facet.adminDrawWinner(1, from_admin)


def test_draw_winner(
    admin,
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
    l2_diamonds.naffle_admin_facet.adminDrawWinner(1, from_admin)

    naffle = l2_diamonds.naffle_view_facet.getNaffleById(1)

    # winning ticket id
    if naffle[11] != 1 and naffle[11] != 2:
        pytest.fail("Naffle winning ticket id is not 1 or 2")

    assert naffle[11] == 2  # paid ticket type
    assert naffle[12] == 4  # naffle status finished


def test_withdraw_platform_fee(
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
    old_balance = admin.balance()
    l2_diamonds.naffle_base_facet.ownerDrawWinner(1, from_address)

    amount_to_withdraw = (TICKET_PRICE * 2 * 0.01)

    assert l2_diamonds.naffle_admin_facet.withdrawPlatformFees(amount_to_withdraw, admin, from_admin)
    assert admin.balance() == old_balance + amount_to_withdraw


def test_withdraw_platform_fee_insufficient_funds(
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
    l2_diamonds.naffle_base_facet.ownerDrawWinner(1, from_address)

    amount_to_withdraw = (TICKET_PRICE * 2 * 0.01)

    with brownie.reverts(get_error_message("InsufficientFunds")):
        assert l2_diamonds.naffle_admin_facet.withdrawPlatformFees(amount_to_withdraw + 1, admin, from_admin)