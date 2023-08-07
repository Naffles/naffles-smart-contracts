from brownie import chain

STANDARD_NAFFLE_TYPE = 0
UNLIMITED_NAFFLE_TYPE = 1
PLATFORM_FEE = 100
OPEN_ENTRY_TICKET_RATIO = 100
NAFFLE_ID = 1
NAFFLE_STATUS_ACTIVE = 0
PAID_TICKET_SPOTS = 2
TICKET_PRICE = 10000
ERC721 = 0
ERC1155 = 1
NFT_ID = 1


def get_end_time():
    return chain.time() + 100000

class L2Diamonds:
    def __init__(
        self,
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
        deployed_l1_messenger_mock,
    ):
        from tests.contracts.naffle.zksync.test_l2_naffle_diamond import (
            setup_l2_naffle_diamond_with_facets,
        )
        from tests.contracts.tokens.zksync.tickets.open_entry.test_l2_open_entry_ticket_base import (
            setup_open_entry_ticket_contract,
        )
        from tests.contracts.tokens.zksync.tickets.open_entry.test_l2_open_entry_ticket_diamond import (
            setup_open_entry_ticket_diamond_with_facets,
        )
        from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_base import (
            setup_paid_ticket_contract,
        )
        from tests.contracts.tokens.zksync.tickets.paid.test_l2_paid_ticket_diamond import (
            setup_paid_ticket_diamond_with_facets,
        )

        (
            self.naffle_access_control,
            self.naffle_base_facet,
            self.naffle_admin_facet,
            self.naffle_view_facet,
        ) = setup_l2_naffle_diamond_with_facets(
            from_admin,
            deployed_l2_naffle_diamond,
            deployed_l2_naffle_base_facet,
            deployed_l2_naffle_admin_facet,
            deployed_l2_naffle_view_facet,
        )

        (
            self.paid_access_control,
            self.paid_base_facet,
            self.paid_admin_facet,
            self.paid_view_facet,
        ) = setup_paid_ticket_diamond_with_facets(
            from_admin,
            deployed_l2_paid_ticket_diamond,
            deployed_l2_paid_ticket_base_facet,
            deployed_l2_paid_ticket_admin_facet,
            deployed_l2_paid_ticket_view_facet,
        )

        (
            self.open_entry_access_control,
            self.open_entry_base_facet,
            self.open_entry_admin_facet,
            self.open_entry_view_facet,
        ) = setup_open_entry_ticket_diamond_with_facets(
            from_admin,
            deployed_l2_open_entry_ticket_diamond,
            deployed_l2_open_entry_ticket_base_facet,
            deployed_l2_open_entry_ticket_admin_facet,
            deployed_l2_open_entry_ticket_view_facet,
        )

        # We set admin as the l1 contract,
        # so we can call create naffle from admin.
        from tests.contracts.naffle.zksync.test_l2_naffle_base import setup_l2_naffle_contract
        setup_l2_naffle_contract(
            self.naffle_admin_facet,
            from_admin["from"],
            deployed_l2_paid_ticket_diamond,
            deployed_l2_open_entry_ticket_diamond,
            deployed_l1_messenger_mock,
            from_admin,
        )
        setup_paid_ticket_contract(
            self.paid_admin_facet, deployed_l2_naffle_diamond, from_admin
        )
        setup_open_entry_ticket_contract(
            self.open_entry_admin_facet, deployed_l2_naffle_diamond, from_admin
        )

        self.deployed_l2_naffle_diamond = deployed_l2_naffle_diamond
        self.deployed_l2_paid_ticket_diamond = deployed_l2_paid_ticket_diamond
        self.deployed_l2_open_entry_ticket_diamond = (
            deployed_l2_open_entry_ticket_diamond
        )
        self.deployed_l1_messenger_mock = deployed_l1_messenger_mock


def create_naffle_and_mint_tickets(
    address,
    from_admin,
    l2_diamonds,
    deployed_erc721a_mock,
    naffle_type=STANDARD_NAFFLE_TYPE,
    number_of_tickets=PAID_TICKET_SPOTS,
    end_time=get_end_time()
):
    l2_diamonds.naffle_base_facet.createNaffle(
        (
            deployed_erc721a_mock.address,
            address,
            NAFFLE_ID,
            NFT_ID,
            number_of_tickets,
            TICKET_PRICE,
            end_time,
            naffle_type,
            ERC721,
        ),
        from_admin,
    )

    l2_diamonds.naffle_base_facet.buyTickets(2, 1, {"from": address, "value": TICKET_PRICE * 2})
    l2_diamonds.open_entry_admin_facet.adminMint(address, 1, from_admin)

