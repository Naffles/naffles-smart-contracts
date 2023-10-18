import datetime

import brownie
from brownie import ZERO_ADDRESS, network
from eth_abi import encode
from tests.conftest import default_collection_signature_params
from web3 import Web3

from scripts.util import ZKSYNC_ADDRESS, get_error_message
from tests.contracts.naffle.ethereum.test_l1_naffle_diamond import (
    setup_diamond_with_facets,
)
from tests.test_helper import ERC20, ERC721

STANDARD_NAFFLE_TYPE = 0
UNLIMITED_NAFFLE_TYPE = 1

MINIMUM_NAFFLE_DURATION = 10
MINIMUM_PAID_TICKET_SPOTS = 2
MINIMUM_TICKET_PRICE = 2


def setup_l1_naffle_contract(
    admin_facet, deployed_founders_key_staking, eth_zksync, from_admin
):
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
    l2_message_params,
    default_collection_signature_params
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
    amount = 1

    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    print(brownie.network.chain.id)

    with brownie.reverts(get_error_message("NotAllowed", [], [])):
        base_facet.createNaffle(
            token_info,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            l2_message_params,
            default_collection_signature_params,
            from_address
        )


def test_create_naffle_invalid_end_time(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
    l2_message_params,
    default_collection_signature_params
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
    amount = 1
    end_time = int(datetime.datetime.now().timestamp()) + 1

    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    with brownie.reverts(get_error_message("InvalidEndTime", ["uint256"], [end_time])):
        base_facet.createNaffle(
            token_info,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            end_time,
            STANDARD_NAFFLE_TYPE,
            l2_message_params,
            default_collection_signature_params,
            from_address
        )


def test_create_naffle_invalid_minimum_paid_ticket_spots(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
    default_collection_signature_params,
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
    nft_id = 1
    amount = 1
    minimum_paid_ticket_spots = MINIMUM_PAID_TICKET_SPOTS - 1
    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    with brownie.reverts(
        get_error_message(
            "InvalidPaidTicketSpots",
            ["uint256"],
            [minimum_paid_ticket_spots],
        )
    ):
        base_facet.createNaffle(
            token_info,
            minimum_paid_ticket_spots,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 10000,
            STANDARD_NAFFLE_TYPE,
            l2_message_params,
            default_collection_signature_params,
            from_address
        )


def test_create_naffle_invalid_minimum_paid_ticket_spots_unlimited_type(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
    default_collection_signature_params,
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
    nft_id = 1
    amount = 1

    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    with brownie.reverts(
        get_error_message(
            "InvalidPaidTicketSpots",
            ["uint256"],
            [MINIMUM_PAID_TICKET_SPOTS],
        )
    ):
        base_facet.createNaffle(
            token_info,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 10000,
            UNLIMITED_NAFFLE_TYPE,
            l2_message_params,
            default_collection_signature_params,
            from_address
        )


def test_create_naffle_invalid_token_type(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
    default_collection_signature_params,
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
    nft_id = 1
    amount = 1
    token_info = (
        ZERO_ADDRESS,
        nft_id,
        amount,
        0
    )
    with brownie.reverts(""):
        base_facet.createNaffle(
            token_info,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            l2_message_params,
            default_collection_signature_params,
            from_address
        )


def test_create_naffle_no_approval(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
    default_collection_signature_params,
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

    nft_id = 1
    amount = 1

    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    with brownie.reverts(get_error_message("TransferCallerNotOwnerNorApproved")):
        base_facet.createNaffle(
            token_info,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            l2_message_params,
            default_collection_signature_params,
            from_address
        )


def test_create_naffle_invalid_gas_supplied(
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
    default_collection_signature_params,
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
    amount = 1

    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    with brownie.reverts(get_error_message("InsufficientL2GasForwardedForCreateNaffle")):
        base_facet.createNaffle(
            token_info,
            MINIMUM_PAID_TICKET_SPOTS,
            MINIMUM_TICKET_PRICE,
            datetime.datetime.now().timestamp() + 1000,
            STANDARD_NAFFLE_TYPE,
            l2_message_params,
            default_collection_signature_params,
            from_address
        )


def test_create_naffle_erc20(
    from_address,
    address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_erc20_mock,
    deployed_eth_zksync_mock,
    collection_signature_params_erc20,
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
        admin_facet, deployed_erc20_mock, deployed_eth_zksync_mock, from_admin
    )
    amount = 100
    deployed_erc20_mock.mint(from_address["from"], amount, from_admin)
    deployed_erc20_mock.approve(
        deployed_l1_naffle_diamond.address, amount, from_address
    )

    token_info = (
        deployed_erc20_mock.address,
        0,
        amount,
        ERC20
    )

    base_facet.createNaffle(
        token_info,
        MINIMUM_PAID_TICKET_SPOTS,
        MINIMUM_TICKET_PRICE,
        datetime.datetime.now().timestamp() + 1000,
        STANDARD_NAFFLE_TYPE,
        l2_message_params,
        collection_signature_params_erc20,
        {'from': address, 'value': 1163284000000000}
    )
    assert deployed_eth_zksync_mock.called()



def test_create_naffle_zksync_called(
    from_address,
    address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_erc721a_mock,
    deployed_eth_zksync_mock,
    default_collection_signature_params,
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
    amount = 1

    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    base_facet.createNaffle(
        token_info,
        MINIMUM_PAID_TICKET_SPOTS,
        MINIMUM_TICKET_PRICE,
        datetime.datetime.now().timestamp() + 1000,
        STANDARD_NAFFLE_TYPE,
        l2_message_params,
        default_collection_signature_params,
        {'from': address, 'value': 1163284000000000}
    )
    assert deployed_eth_zksync_mock.called()


def test_process_message_from_l2_set_winner(
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
    default_collection_signature_params,
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
    amount = 1

    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    base_facet.createNaffle(
        token_info,
        MINIMUM_PAID_TICKET_SPOTS,
        MINIMUM_TICKET_PRICE,
        datetime.datetime.now().timestamp() + 100000,
        STANDARD_NAFFLE_TYPE,
        l2_message_params,
        default_collection_signature_params,
        {'from': address, 'value': 1163284000000000}
    )

    _naffleId = 1

    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    action = "setWinner"

    encoded_data = encode(["string", "uint256", "address"], [action, _naffleId, address.address])
    keccak_encoded_data = Web3.keccak(encoded_data)
    base_facet.consumeSetWinnerMessage(
        _l2BlockNumber,
        _index,
        _l2TxNumberInBlock,
        # cancel, 1
        keccak_encoded_data,
        encoded_data,
        _proof,
        from_admin
    )

    assert deployed_erc721a_mock.ownerOf(nft_id) == address.address
    assert view_facet.getNaffleById(_naffleId, from_address)[3] == address.address


def test_process_message_from_l2_set_winner_erc20(
    address,
    from_address,
    from_admin,
    deployed_l1_naffle_diamond,
    deployed_l1_naffle_base_facet,
    deployed_l1_naffle_admin_facet,
    deployed_l1_naffle_view_facet,
    deployed_founders_key_staking,
    deployed_erc20_mock,
    deployed_eth_zksync_mock,
    zksync_l1_message_account,
    collection_signature_params_erc20,
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
        admin_facet, deployed_erc20_mock, deployed_eth_zksync_mock, from_admin
    )
    amount = 100
    deployed_erc20_mock.mint(from_address["from"], 100, from_admin)
    deployed_erc20_mock.approve(
        deployed_l1_naffle_diamond.address, 100, from_address
    )

    token_info = (
        deployed_erc20_mock.address,
        0,
        amount,
        ERC20
    )

    base_facet.createNaffle(
        token_info,
        MINIMUM_PAID_TICKET_SPOTS,
        MINIMUM_TICKET_PRICE,
        datetime.datetime.now().timestamp() + 100000,
        STANDARD_NAFFLE_TYPE,
        l2_message_params,
        collection_signature_params_erc20,
        {'from': address, 'value': 1163284000000000}
    )
    assert deployed_erc20_mock.balanceOf(deployed_l1_naffle_diamond.address) == 100

    _naffleId = 1
    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    action = "setWinner"

    encoded_data = encode(["string", "uint256", "address"], [action, _naffleId, address.address])
    keccak_encoded_data = Web3.keccak(encoded_data)
    base_facet.consumeSetWinnerMessage(
        _l2BlockNumber,
        _index,
        _l2TxNumberInBlock,
        # cancel, 1
        keccak_encoded_data,
        encoded_data,
        _proof,
        from_admin
    )

    assert deployed_erc20_mock.balanceOf(deployed_l1_naffle_diamond.address) == 0
    assert deployed_erc20_mock.balanceOf(address.address) == 100


def test_process_message_from_l2_set_winner(
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
    l2_message_params,
    default_collection_signature_params,
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
    amount = 1

    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    base_facet.createNaffle(
        token_info,
        MINIMUM_PAID_TICKET_SPOTS,
        MINIMUM_TICKET_PRICE,
        datetime.datetime.now().timestamp() + 100000,
        STANDARD_NAFFLE_TYPE,
        l2_message_params,
        default_collection_signature_params,
        {'from': address, 'value': 1163284000000000}
    )

    _naffleId = 1

    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    action = "setWinner"

    encoded_data = encode(["string", "uint256", "address"], [action, _naffleId, address.address])
    keccak_encoded_data = Web3.keccak(encoded_data)
    base_facet.consumeSetWinnerMessage(
        _l2BlockNumber,
        _index,
        _l2TxNumberInBlock,
        # cancel, 1
        keccak_encoded_data,
        encoded_data,
        _proof,
        from_admin
    )

    assert deployed_erc721a_mock.ownerOf(nft_id) == address.address
    assert view_facet.getNaffleById(_naffleId, from_address)[3] == address.address


def test_process_message_from_l2_set_winner_invalid_hash(
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
    l2_message_params,
    default_collection_signature_params,
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
    amount = 1

    token_info = (
        deployed_erc721a_mock.address,
        nft_id,
        amount,
        0
    )

    base_facet.createNaffle(
        token_info,
        MINIMUM_PAID_TICKET_SPOTS,
        MINIMUM_TICKET_PRICE,
        datetime.datetime.now().timestamp() + 100000,
        STANDARD_NAFFLE_TYPE,
        l2_message_params,
        default_collection_signature_params,
        {'from': address, 'value': 1163284000000000}
    )

    _naffleId = 1

    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    action = "setWinner"

    encoded_data = encode(["string", "uint256", "address"], [action, _naffleId, address.address])
    keccak_encoded_data = Web3.keccak(encode(["string", "uint256", "address"], [action, 2, address.address]))
    with brownie.reverts(get_error_message("FailedMessageInclusion")):
        base_facet.consumeSetWinnerMessage(
            _l2BlockNumber,
            _index,
            _l2TxNumberInBlock,
            # cancel, 1
            keccak_encoded_data,
            encoded_data,
            _proof,
            from_admin
        )

def test_process_message_from_l2_set_winner_failed_message_inclusion(
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
        admin_facet, deployed_erc721a_mock, deployed_eth_zksync_mock_false_return_values, from_admin
    )

    _l2BlockNumber = 123
    _index = 0
    _l2TxNumberInBlock = 1
    _proof = ["0x01"]

    action = "setWinner"

    encoded_data = encode(["string", "uint256", "address"], [action, 1, address.address])
    keccak_encoded_data = Web3.keccak(encoded_data)
    with brownie.reverts(get_error_message("FailedMessageInclusion")):
        base_facet.consumeSetWinnerMessage(
            _l2BlockNumber,
            _index,
            _l2TxNumberInBlock,
            # cancel, 1
            keccak_encoded_data,
            encoded_data,
            _proof,
            from_admin
        )
