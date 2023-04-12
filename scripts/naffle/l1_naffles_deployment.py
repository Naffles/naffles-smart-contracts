from brownie.network.account import Account

from brownie import (
    L1MessengerMock,
    ETHZkSyncMock,
    accounts,
    interface,
)

from scripts.naffle.ethereum.deploy_l1_naffle_diamond import deploy as deploy_l1_naffle_diamond
from scripts.naffle.zksync.deploy_l2_naffle_diamond import deploy as deploy_l2_naffle_diamond
from scripts.tokens.zksync.ticket.open_entry import deploy as deploy_open_entry_ticket
from scripts.tokens.zksync.ticket.paid.deploy_l2_naffle_diamond import deploy as deploy_paid_ticket


def deploy(
    account: Account | None = None,
    publish_source: bool = True,
):
    if not account:
        account = accounts.load("naffle")

    from_account = {"from": account}
    deployed_l1_messenger = L1MessengerMock.deploy({"from": account}, publish_source=publish_source)
    deployed_eth_zksync_mock = ETHZkSyncMock.deploy(True, True, True, {"from": account}, publish_source=publish_source)

    (
        l1_diamond_access_control,
        l1_diamond_base_facet,
        l1_diamond_admin_facet,
        l1_diamond_view_facet,
    ) = deploy_l1_naffle_diamond(account, publish_source)

    (
        l2_diamond_access_control,
        l2_diamond_base_facet,
        l2_diamond_admin_facet,
        l2_diamond_view_facet,
    ) = deploy_l2_naffle_diamond(account, publish_source)

    (
        l2_open_entry_ticket_access_control,
        l2_open_entry_ticket_base_facet,
        l2_open_entry_ticket_admin_facet,
        l2_open_entry_ticket_view_facet,
    ) = deploy_open_entry_ticket(account, publish_source)

    (
        l2_paid_ticket_access_control,
        l2_paid_ticket_base_facet,
        l2_paid_ticket_admin_facet,
        l2_paid_ticket_view_facet,
    ) = deploy_paid_ticket(account, publish_source)

    # setting up l1_naffle_diamond
    l1_diamond_admin_facet.setMinimumNaffleDuration(MINIMUM_NAFFLE_DURATION, from_account)
    l1_diamond_admin_facet.setMinimumPaidTicketSpots(MINIMUM_PAID_TICKET_SPOTS, from_account)
    l1_diamond_admin_facet.setMinimumPaidTicketPriceInWei(MINIMUM_TICKET_PRICE, from_account)
    l1_diamond_admin_facet.setZkSyncAddress(eth_zksync.address, from_account)
    l1_diamond_admin_facet.setZkSyncNaffleContractAddress(ZKSYNC_ADDRESS, from_account)
    l1_diamond_admin_facet.setFoundersKeyAddress(deployed_founders_key_staking.address, from_account)
    l1_diamond_admin_facet.setFoundersKeyPlaceholderAddress(
        deployed_founders_key_staking.address, from_account
    )


