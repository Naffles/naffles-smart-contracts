// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {L1NaffleBaseStorage} from "../base/L1NaffleBaseStorage.sol";
import {NaffleTypes} from "../../../libraries/NaffleTypes.sol";

abstract contract L1NaffleAdminInternal {
    function _setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) internal {
        L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress = _zkSyncNaffleContractAddress;
    }
}
