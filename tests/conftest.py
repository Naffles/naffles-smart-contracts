import pytest
from brownie import (
    ERC721AMock,
    ETHZkSyncMock,
    FoundersKeyStaking,
    L1MessengerMock,
    L1NaffleAdmin,
    L1NaffleBase,
    L1NaffleDiamond,
    L1NaffleView,
    L2NaffleAdmin,
    L2NaffleBase,
    L2NaffleDiamond,
    L2NaffleView,
    L2OpenEntryTicketAdmin,
    L2OpenEntryTicketBase,
    L2OpenEntryTicketDiamond,
    L2OpenEntryTicketView,
    L2PaidTicketAdmin,
    L2PaidTicketBase,
    L2PaidTicketDiamond,
    L2PaidTicketView,
    SoulboundFoundersKey,
    TestNaffleDiamond,
    TestValueFacet,
    TestValueFacetUpgraded,
    accounts,
)
from brownie.network.account import _PrivateKeyAccount, Account

from tests.test_helper import L2Diamonds


@pytest.fixture
def admin() -> _PrivateKeyAccount:
    return accounts[0]


@pytest.fixture
def address() -> _PrivateKeyAccount:
    return accounts[1]


@pytest.fixture
def from_address(address) -> dict:
    return {"from": address}


@pytest.fixture
def private_key() -> str:
    return "0b1ce493b94b0ebb664d355548c097f4bab74b5cb55fc5feb4c5fcddb67484e8"


@pytest.fixture
def from_admin(admin) -> dict:
    return {"from": admin}


@pytest.fixture()
def deployed_test_naffle_diamond(from_admin) -> TestNaffleDiamond:
    diamond = TestNaffleDiamond.deploy(from_admin)
    return diamond


@pytest.fixture()
def deployed_l1_naffle_diamond(admin, from_admin) -> L1NaffleDiamond:
    diamond = L1NaffleDiamond.deploy(admin, from_admin)
    return diamond


@pytest.fixture()
def deployed_l1_naffle_base_facet(from_admin) -> L1NaffleBase:
    facet = L1NaffleBase.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l1_naffle_admin_facet(from_admin) -> L1NaffleAdmin:
    facet = L1NaffleAdmin.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l1_naffle_view_facet(from_admin) -> L1NaffleView:
    facet = L1NaffleView.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l2_naffle_diamond(admin, from_admin) -> L2NaffleDiamond:
    diamond = L2NaffleDiamond.deploy(admin, from_admin)
    return diamond


@pytest.fixture()
def deployed_l2_naffle_base_facet(from_admin) -> L2NaffleBase:
    facet = L2NaffleBase.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l2_naffle_admin_facet(from_admin) -> L2NaffleAdmin:
    facet = L2NaffleAdmin.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l2_naffle_view_facet(from_admin) -> L2NaffleView:
    facet = L2NaffleView.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l2_paid_ticket_diamond(admin, from_admin) -> L2PaidTicketDiamond:
    diamond = L2PaidTicketDiamond.deploy(admin, from_admin)
    return diamond


@pytest.fixture()
def deployed_l2_paid_ticket_base_facet(from_admin) -> L2PaidTicketBase:
    facet = L2PaidTicketBase.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l2_paid_ticket_admin_facet(from_admin) -> L2PaidTicketAdmin:
    facet = L2PaidTicketAdmin.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l2_paid_ticket_view_facet(from_admin) -> L2PaidTicketView:
    facet = L2PaidTicketView.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l2_open_entry_ticket_diamond(
    admin, from_admin
) -> L2OpenEntryTicketDiamond:
    diamond = L2OpenEntryTicketDiamond.deploy(admin, from_admin)
    return diamond


@pytest.fixture()
def deployed_l2_open_entry_ticket_base_facet(from_admin) -> L2OpenEntryTicketBase:
    facet = L2OpenEntryTicketBase.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l2_open_entry_ticket_admin_facet(from_admin) -> L2OpenEntryTicketAdmin:
    facet = L2OpenEntryTicketAdmin.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_l2_open_entry_ticket_view_facet(from_admin) -> L2OpenEntryTicketView:
    facet = L2OpenEntryTicketView.deploy(from_admin)
    return facet


@pytest.fixture()
def l2_diamonds(
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
) -> L2NaffleDiamond:
    return L2Diamonds(
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
        deployed_l1_messenger_mock
    )


@pytest.fixture()
def deployed_test_facet(from_admin) -> TestValueFacet:
    facet = TestValueFacet.deploy(from_admin)
    return facet


@pytest.fixture()
def deployed_test_facet_upgraded(from_admin) -> TestValueFacetUpgraded:
    facet = TestValueFacetUpgraded.deploy(from_admin)
    return facet


@pytest.fixture
def deployed_erc721a_mock(from_admin) -> ERC721AMock:
    return ERC721AMock.deploy(from_admin)


@pytest.fixture
def deployed_eth_zksync_mock(from_admin) -> ETHZkSyncMock:
    return ETHZkSyncMock.deploy(True, True, True, from_admin)


@pytest.fixture
def deployed_eth_zksync_mock_false_return_values(from_admin) -> ETHZkSyncMock:
    return ETHZkSyncMock.deploy(False, False, False, from_admin)


@pytest.fixture
def deployed_soulbound(
    deployed_erc721a_mock, from_admin, admin
) -> SoulboundFoundersKey:
    soulbound = SoulboundFoundersKey.deploy(deployed_erc721a_mock.address, from_admin)
    soulbound.grantRole(soulbound.STAKING_CONTRACT_ROLE(), admin.address, from_admin)
    return soulbound


@pytest.fixture
def deployed_founders_key_staking(
    deployed_soulbound, deployed_erc721a_mock, from_admin
) -> FoundersKeyStaking:
    staking = FoundersKeyStaking.deploy(
        deployed_erc721a_mock.address, deployed_soulbound.address, from_admin
    )
    deployed_soulbound.grantRole(
        deployed_soulbound.STAKING_CONTRACT_ROLE(), staking.address, from_admin
    )
    return staking


@pytest.fixture
def zksync_l1_message_account() -> Account:
    return accounts.at('0x79B2f0CbED2a565C925A8b35f2B402710564F8a2', force=True)


@pytest.fixture
def deployed_l1_messenger_mock(from_admin) -> L1MessengerMock:
    return L1MessengerMock.deploy(from_admin)