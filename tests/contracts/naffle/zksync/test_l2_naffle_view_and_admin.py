import datetime

import brownie
from brownie import L2NaffleAdmin

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
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )
    with brownie.reverts(get_error_message("OpenTicketRatioCannotBeZero")):
        admin_facet.setFreeTicketRatio(0, from_admin)


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
    address,
    from_admin,
    deployed_l2_paid_ticket_diamond,
    deployed_l2_paid_ticket_base_facet,
    deployed_l2_paid_ticket_admin_facet,
    deployed_l2_paid_ticket_view_facet,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
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
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_view_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_base_facet,
        deployed_erc721a_mock,
    )

    naffle = brownie.interface.IL2NaffleView(deployed_l2_naffle_diamond).getNaffleById(
        1
    )

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
