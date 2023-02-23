// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {L1NaffleBaseStorage} from "../base/L1NaffleBaseStorage.sol";
import {L1NaffleAdminInternal} from "./L1NaffleAdminInternal.sol";
import {NaffleTypes} from "../../../libraries/NaffleTypes.sol";
import {IZkSync} from "@zksync/contracts/l1/zksync/interfaces/IZkSync.sol";

abstract contract L1NaffleAdmin is L1NaffleAdminInternal {
    function setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) external {
        _setZkSyncNaffleContractAddress(_zkSyncNaffleContractAddress);
    }
}
