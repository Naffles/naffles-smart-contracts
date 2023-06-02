import datetime

import brownie
from brownie import ZERO_ADDRESS, L1NaffleAdmin
from eth_abi import encode

from scripts.util import add_facet, get_selectors, get_error_message
from tests.contracts.naffle.ethereum.test_l1_naffle_base import setup_l1_naffle_contract, MINIMUM_PAID_TICKET_SPOTS, \
    MINIMUM_TICKET_PRICE
from tests.contracts.naffle.ethereum.test_l1_naffle_diamond import (
    setup_diamond_with_facets,
)
from tests.test_helper import STANDARD_NAFFLE_TYPE, ERC721

TEST_ADDRESS = "0xb3D0248016434793037ED3abF8865d701f40AA82"


def test_admin_facet_deployment(
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_admin_facet,
):
    start_facet_number = len(deployed_l1_naffle_diamond.facets())

    add_facet(
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_admin_facet,
        from_admin,
        get_selectors(L1NaffleAdmin),
    )

    assert len(deployed_l1_naffle_diamond.facets()) == start_facet_number + 1


def test_get_and_set_minimum_naffle_duration(
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    admin_facet.setMinimumNaffleDuration(1, from_admin)

    assert view_facet.getMinimumNaffleDuration() == 1


def test_get_and_set_minimum_naffle_duration_not_admin(
    from_admin,
    from_address,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    with brownie.reverts():
        admin_facet.setMinimumNaffleDuration(1, from_address)


def test_get_and_set_minimum_paid_ticket_spots(
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    admin_facet.setMinimumPaidTicketSpots(1, from_admin)

    assert view_facet.getMinimumPaidTicketSpots() == 1


def test_get_and_set_minimum_paid_ticket_spots_not_admin(
    from_admin,
    from_address,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    with brownie.reverts():
        admin_facet.setMinimumPaidTicketSpots(1, from_address)


def test_get_and_set_minimum_ticket_price(
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    admin_facet.setMinimumPaidTicketPriceInWei(1, from_admin)

    assert view_facet.getMinimumPaidTicketPriceInWei() == 1


def test_set_minimum_ticket_price_not_admin(
    from_admin,
    from_address,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    with brownie.reverts():
        admin_facet.setMinimumPaidTicketPriceInWei(1, from_address)


def test_get_and_set_zksync_naffle_contract_address(
    admin,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    admin_facet.setZkSyncNaffleContractAddress(admin, from_admin)

    assert view_facet.getZkSyncNaffleContractAddress() == admin


def test_get_and_set_zksync_naffle_contract_address_not_admin(
    from_admin,
    from_address,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    with brownie.reverts():
        admin_facet.setZkSyncNaffleContractAddress(ZERO_ADDRESS, from_address)


def test_get_and_set_zksync_address(
    admin,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    admin_facet.setZkSyncAddress(admin, from_admin)

    assert view_facet.getZkSyncAddress() == admin


def test_get_and_set_zksync_address_not_admin(
    from_admin,
    from_address,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    with brownie.reverts():
        admin_facet.setZkSyncAddress(ZERO_ADDRESS, from_address)


def test_get_and_set_founders_key_address(
    admin,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    admin_facet.setFoundersKeyAddress(admin, from_admin)

    assert view_facet.getFoundersKeyAddress() == admin


def test_set_founders_key_address_not_admin(
    from_admin,
    from_address,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    with brownie.reverts():
        admin_facet.setFoundersKeyAddress(ZERO_ADDRESS, from_address)


def test_set_founders_key_placeholder_address(
    admin,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    admin_facet.setFoundersKeyPlaceholderAddress(admin, from_admin)

    assert view_facet.getFoundersKeyPlaceholderAddress() == admin


def test_get_and_set_admin_address(
    address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    admin_facet.setAdmin(address, from_admin)

    assert access_control.hasRole(view_facet.getAdminRole(), address)


def test_set_admin_address_not_admin(
    address,
    from_admin,
    from_address,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    with brownie.reverts():
        admin_facet.setAdmin(address, from_address)


def test_process_message_from_l2_cancel_naffle(
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
    zksync_l1_message_account,
    l2_message_params
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
        l2_message_params,
        from_address
    )

    _naffleId = 1

    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    action = "cancel"
    one = 1

    encoded_data = encode(["string", "uint256"], [action, one])
    admin_facet.consumeAdminCancelMessage(
        _l2BlockNumber,
        _index,
        _l2TxNumberInBlock,
        # cancel, 1
        encoded_data,
        _proof,
        from_admin
    )

    assert view_facet.getNaffleById(_naffleId, from_address) == (
        deployed_erc721a_mock.address,
        nft_id,
        _naffleId,
        address,
        ZERO_ADDRESS,
        True,
        ERC721,
    )


def test_process_message_from_l2_message_already_processed(
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
    zksync_l1_message_account,
    l2_message_params
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
        l2_message_params,
        from_address,
    )

    _naffleId = 1

    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    action = "cancel"
    one = 1

    encoded_data = encode(["string", "uint256"], [action, one])
    admin_facet.consumeAdminCancelMessage(
        _l2BlockNumber,
        _index,
        _l2TxNumberInBlock,
        # cancel, 1
        encoded_data,
        _proof,
        from_admin
    )

    with brownie.reverts(get_error_message("MessageAlreadyProcessed")):
        admin_facet.consumeAdminCancelMessage(
            _l2BlockNumber,
            _index,
            _l2TxNumberInBlock,
            # cancel, 1
            encoded_data,
            _proof,
            from_admin
        )


def test_process_message_from_l2_message_not_allowed(
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
    _naffleId = 1

    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    action = "cancel"
    one = 1

    encoded_data = encode(["string", "uint256"], [action, one])
    with brownie.reverts():
        admin_facet.consumeAdminCancelMessage(
            _l2BlockNumber,
            _index,
            _l2TxNumberInBlock,
            # cancel, 1
            encoded_data,
            _proof,
            from_address
        )


def test_process_message_from_l2_failed_message_inclusion(
    address,
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock_false_return_values,
    zksync_l1_message_account,
    l2_message_params
):
    access_control, base_facet, admin_facet, view_facet = setup_diamond_with_facets(
        from_admin,
        deployed_l1_naffle_diamond,
        deployed_l1_naffle_base_facet,
        deployed_l1_naffle_admin_facet,
        deployed_l1_naffle_view_facet,
    )
    setup_l1_naffle_contract(
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock_false_return_values, from_admin
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
        l2_message_params,
        from_address,
    )

    _naffleId = 1

    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    action = "cancel"
    one = 1

    encoded_data = encode(["string", "uint256"], [action, one])
    with brownie.reverts(get_error_message("FailedMessageInclusion")):
        admin_facet.consumeAdminCancelMessage(
            _l2BlockNumber,
            _index,
            _l2TxNumberInBlock,
            # cancel, 1
            encoded_data,
            _proof,
            from_admin
        )