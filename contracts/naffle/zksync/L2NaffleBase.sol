// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseInternal.sol";
import "../../libraries/NaffleTypes.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleBase.sol";

contract L2NaffleBase is IL2NaffleBase, L2NaffleBaseInternal, AccessControl {
    function createNaffle(
        NaffleTypes.CreateZkSyncNaffleParams _params
    ) external {
        return _createNaffle(
            _params
        );
    }
}
