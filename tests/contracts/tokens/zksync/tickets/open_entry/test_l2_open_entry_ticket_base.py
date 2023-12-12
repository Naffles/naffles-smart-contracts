import brownie
from brownie import accounts, Contract, ERC721AMock

from scripts.util import get_error_message
from tests.contracts.tokens.zksync.tickets.open_entry.test_l2_open_entry_ticket_diamond import (
    setup_open_entry_ticket_diamond_with_facets,
)
from tests.test_helper import (
    NAFFLE_ID,
    NAFFLE_STATUS_ACTIVE,
    create_naffle_and_mint_tickets,
)


def setup_open_entry_ticket_contract(admin_facet, naffle_contract, from_admin):
    admin_facet.setL2NaffleContractAddress(naffle_contract.address, from_admin)


def test_admin_mint(
    admin,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    admin_facet.adminMint(admin, 1, from_admin)
    erc721_contract = Contract.from_abi("ERC721AMock", deployed_l2_open_entry_ticket_diamond.address, ERC721AMock.abi)
    assert erc721_contract.totalSupply() == 1
    ticket = view_facet.getOpenEntryTicketById(1, from_admin)
    naffle_id = 0
    ticket_id_on_naffle = 0

    assert ticket == (naffle_id, ticket_id_on_naffle)


def test_admin_mint_no_admin(
    admin,
    from_address,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    with brownie.reverts():
        admin_facet.adminMint(admin, 1, from_address)

    erc721_contract = Contract.from_abi("ERC721AMock", deployed_l2_open_entry_ticket_diamond.address, ERC721AMock.abi)
    assert erc721_contract.totalSupply() == 0



def test_attach_to_naffle(
    admin,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    setup_open_entry_ticket_contract(admin_facet, admin, from_admin)
    amount = 1
    admin_facet.adminMint(admin, amount, from_admin)
    naffle_id = 1
    ticket_id_on_naffle = 1

    base_facet.attachToNaffle(
        naffle_id, [ticket_id_on_naffle], ticket_id_on_naffle, admin, from_admin
    )

    ticket = view_facet.getOpenEntryTicketById(1, from_admin)

    assert ticket == (naffle_id, ticket_id_on_naffle)


def test_attach_to_naffle_not_owner_of_ticket(
    admin,
    address,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    setup_open_entry_ticket_contract(admin_facet, admin, from_admin)
    amount = 1
    admin_facet.adminMint(admin, amount, from_admin)
    naffle_id = 1
    ticket_id_on_naffle = 1

    with brownie.reverts(get_error_message("NotOwnerOfTicket", ["uint256"], [1])):
        base_facet.attachToNaffle(
            naffle_id, [ticket_id_on_naffle], ticket_id_on_naffle, address, from_admin
        )


def test_attach_to_naffle_ticket_already_used(
    admin,
    from_admin,
    deployed_l2_open_entry_ticket_diamond,
    deployed_l2_open_entry_ticket_base_facet,
    deployed_l2_open_entry_ticket_admin_facet,
    deployed_l2_open_entry_ticket_view_facet,
):
    (
        access_control,
        base_facet,
        admin_facet,
        view_facet,
    ) = setup_open_entry_ticket_diamond_with_facets(
        from_admin,
        deployed_l2_open_entry_ticket_diamond,
        deployed_l2_open_entry_ticket_base_facet,
        deployed_l2_open_entry_ticket_admin_facet,
        deployed_l2_open_entry_ticket_view_facet,
    )

    setup_open_entry_ticket_contract(admin_facet, admin, from_admin)
    amount = 1
    admin_facet.adminMint(admin, amount, from_admin)
    naffle_id = 1
    ticket_id_on_naffle = 1

    base_facet.attachToNaffle(
        naffle_id, [ticket_id_on_naffle], ticket_id_on_naffle, admin, from_admin
    )
    with brownie.reverts(get_error_message("TicketAlreadyUsed", ["uint256"], [1])):
        base_facet.attachToNaffle(
            naffle_id, [ticket_id_on_naffle], ticket_id_on_naffle, admin, from_admin
        )


def test_detach_from_naffle_naffle_not_cancelled(
    from_address, address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address, from_admin, l2_diamonds, deployed_erc721a_mock, number_of_tickets=200
    )
    ticket_id_on_naffle = 1

    l2_diamonds.open_entry_base_facet.attachToNaffle(
        NAFFLE_ID, [ticket_id_on_naffle], ticket_id_on_naffle, address,
        {"from": accounts.at(l2_diamonds.deployed_l2_naffle_diamond.address, force=True)}
    )
    with brownie.reverts(
        get_error_message("NaffleNotCancelled", ["uint8"], [NAFFLE_STATUS_ACTIVE])
    ):
        l2_diamonds.open_entry_base_facet.detachFromNaffle(
            NAFFLE_ID, [ticket_id_on_naffle],
            {"from": accounts.at(l2_diamonds.deployed_l2_naffle_diamond.address, force=True)}
        )


def test_detach_from_naffle_invalid_ticket_id(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )
    ticket_id_on_naffle = 1

    l2_diamonds.open_entry_base_facet.attachToNaffle(
        NAFFLE_ID, [ticket_id_on_naffle], ticket_id_on_naffle, address,
        {"from": accounts.at(l2_diamonds.deployed_l2_naffle_diamond.address, force=True)}
    )

    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)

    with brownie.reverts(get_error_message("InvalidTicketId", ["uint256"], [2])):
        l2_diamonds.open_entry_base_facet.detachFromNaffle(
            NAFFLE_ID, [2],
            {"from": accounts.at(l2_diamonds.deployed_l2_naffle_diamond.address, force=True)}
        )


def test_detach_from_naffle_success(
    address, from_address, admin, from_admin, l2_diamonds, deployed_erc721a_mock
):
    create_naffle_and_mint_tickets(
        address,
        from_admin,
        l2_diamonds,
        deployed_erc721a_mock,
        number_of_tickets=200,
    )
    ticket_id_on_naffle = 1

    l2_diamonds.open_entry_base_facet.attachToNaffle(
        NAFFLE_ID, [ticket_id_on_naffle], ticket_id_on_naffle, address,
        {"from":  accounts.at(l2_diamonds.deployed_l2_naffle_diamond.address, force=True)}
    )
    l2_diamonds.naffle_admin_facet.adminCancelNaffle(NAFFLE_ID, from_admin)
    l2_diamonds.open_entry_base_facet.detachFromNaffle(
        NAFFLE_ID, [ticket_id_on_naffle],
        {"from": accounts.at(l2_diamonds.deployed_l2_naffle_diamond.address, force=True)}
    )
    ticket = l2_diamonds.open_entry_view_facet.getOpenEntryTicketById(1)
    assert ticket == (0, 0)
