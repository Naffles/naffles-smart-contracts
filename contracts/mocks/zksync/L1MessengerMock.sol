// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IL1Messenger.sol";

contract L1MessengerMock is IL1Messenger {
    bool public called = false;

    error NotAllowed();
    function sendToL1(bytes memory _message) external returns (bytes32) {
        called = true;
        return bytes32(0);
    }
}
