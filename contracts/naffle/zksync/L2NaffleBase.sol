// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseInternal.sol";
import "../../libraries/NaffleTypes.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleBase.sol";
import "@zksync/contracts/l2/system-contracts/interfaces/IL1Messenger.sol";

contract L2NaffleBase is IL2NaffleBase, L2NaffleBaseInternal, AccessControl {
    modifier onlyL1NaffleContract() {
        if (msg.sender != _getL1NaffleContractAddress()) {
            revert NotAllowed();
        }
        _;
    }

    function createNaffle(
        NaffleTypes.CreateZkSyncNaffleParams memory _params
    ) external onlyL1NaffleContract {
        _createNaffle(
            _params
        );
    }

    function buyTickets(
        uint256 _amount,
        uint256 _naffleId
    ) external payable returns (uint256[] memory) {
        return _buyTickets(
            _amount,
            _naffleId
        );
    }

    function useOpenEntryTickets(
        uint256[] memory _ticketIds,
        uint256 _naffleId
    ) external {
        _useOpenEntryTickets(
            _ticketIds,
            _naffleId
        );
    }

    function postponeNaffle(
        uint256 _naffleId,
        uint256 _newEndTime
    ) external {
        _postponeNaffle(
            _naffleId,
            _newEndTime
        );
    }
}
