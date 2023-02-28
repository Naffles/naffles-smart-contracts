import datetime

import brownie
from brownie import L2NaffleAdmin

from scripts.util import get_selectors, add_facet, NULL_ADDRESS
from tests.contracts.naffle.zksync.test_l2_naffle_base import _setup_contract, \
    STANDARD_NAFFLE_TYPE, ERC721
from tests.contracts.naffle.zksync.test_l2_naffle_diamond import setup_diamond_with_facets

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
    admin,
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
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l2_naffle_diamond,
        deployed_l2_naffle_base_facet,
        deployed_l2_naffle_admin_facet,
        deployed_l2_naffle_view_facet,
    )

    with brownie.reverts():
        admin_facet.setPlatformFee(1, from_address)


def test_get_and_set_free_ticket_ratio(
    admin,
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
    admin_facet.setFreeTicketRatio(1, from_admin)

    assert view_facet.getFreeTicketRatio() == 1


def test_set_free_ticket_ratio_not_admin(
    from_admin,
    from_address,
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
    with brownie.reverts():
        admin_facet.setFreeTicketRatio(1, from_address)


def test_get_and_set_l1_naffle_contract_address(
    admin,
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
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
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
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
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
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
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
    deployed_erc721a_mock,
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
    _setup_contract(admin_facet, from_admin["from"], from_admin)

    naffle_id = 1
    nft_id = 1
    paid_ticket_spots = 2
    ticket_price = 100
    end_time = datetime.datetime.now().timestamp() + 1000
    naffle_type = STANDARD_NAFFLE_TYPE
    contract_type = ERC721

    base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            address,
            naffle_id,
            nft_id,
            paid_ticket_spots,
            ticket_price,
            end_time,
            naffle_type,
            contract_type,
        ),
        from_admin
    )

    naffle = view_facet.getNaffleById(naffle_id)
    expected_free_ticket_spots = 0
    expected_number_of_tickets_bought = 0
    expected_naffle_status = 0  # active
    expected_winning_ticket_type = 0  # none
    expected_winning_ticket_id = 0

    assert naffle == (
        deployed_erc721a_mock.address,
        address,
        naffle_id,
        nft_id,
        paid_ticket_spots,
        expected_free_ticket_spots,
        expected_number_of_tickets_bought,
        expected_number_of_tickets_bought,
        ticket_price,
        end_time,
        expected_winning_ticket_id,
        expected_winning_ticket_type,
        expected_naffle_status,
        contract_type,
        naffle_type
    )





