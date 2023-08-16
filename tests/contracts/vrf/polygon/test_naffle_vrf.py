import brownie

from scripts.util import get_error_message


def test_constructor(naffle_vrf, admin):
    assert naffle_vrf.VRFManager() == admin


def test_set_chainlink_vrf_settings(naffle_vrf, from_admin):
    naffle_vrf.setChainlinkVRFSettings(2, "0xabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdef", 200000, 5, from_admin)
    assert naffle_vrf.chainlinkVRFSubscriptionId() == 2
    assert naffle_vrf.chainlinkVRFGasLaneKeyHash() == "0xabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdef"
    assert naffle_vrf.chainlinkVRFCallbackGasLimit() == 200000
    assert naffle_vrf.chainlinkVRFRequestConfirmations() == 5


def test_set_vrf_manager(naffle_vrf, address, from_admin):
    naffle_vrf.setVRFManager(address, from_admin)
    assert naffle_vrf.VRFManager() == address


def test_fulfill_random_words(naffle_vrf, from_admin, coordinator_mock):
    naffle_vrf.drawWinner(1, from_admin)
    coordinator_mock.callFulfillRandomWords(1)
    result = naffle_vrf.chainlinkRequestStatus(1)
    assert result[0] # fulfilled
    assert result[1] # exists
    assert result[2] == 2 # randomNumber from mock


def test_draw_winner_already_drawn(naffle_vrf, from_admin, coordinator_mock):
    naffle_vrf.drawWinner(1, from_admin)
    with brownie.reverts(get_error_message("naffleAlreadyRolled", ["uint256"], [1])):
        naffle_vrf.drawWinner(1, from_admin)


def test_fulfill_random_words_invalid_request_id(naffle_vrf, from_admin, coordinator_mock):
    with brownie.reverts():
        coordinator_mock.callFulfillRandomWords(1)