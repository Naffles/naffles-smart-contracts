// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/*
 * @dev libary used for signature verification
 */ 
library Signature {
    function splitSignature(bytes memory sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(sig.length == 65, "Invalid signature length");

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    function getSigner(bytes32 messageHash, bytes memory sig) internal pure returns (address) {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
        return ecrecover(messageHash, v, r, s);
    }
}
