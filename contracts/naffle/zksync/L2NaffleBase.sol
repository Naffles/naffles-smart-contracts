// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2NaffleBaseInternal.sol";
import "../../libraries/NaffleTypes.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "../../../interfaces/naffle/zksync/IL2NaffleBase.sol";
import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IL1Messenger.sol";

contract L2NaffleBase is IL2NaffleBase, L2NaffleBaseInternal, AccessControl {
    modifier onlyL1NaffleContract() {
        if (msg.sender != _getL1NaffleContractAddress()) {
            revert NotAllowed();
        }
        _;
    }

    /**
     * @inheritdoc IL2NaffleBase
     */
    function createNaffle(
        NaffleTypes.CreateZkSyncNaffleParams memory _params
    ) external onlyL1NaffleContract {
        _createNaffle(
            _params
        );
    }

    /**
     * @inheritdoc IL2NaffleBase
     */
    function buyTickets(
        uint256 _amount,
        uint256 _naffleId
    ) external payable returns (uint256[] memory) {
        return _buyTickets(
            _amount,
            _naffleId
        );
    }

    /**
     * @inheritdoc IL2NaffleBase
     */
    function useOpenEntryTickets(
        uint256[] memory _ticketIds,
        uint256 _naffleId
    ) external {
        _useOpenEntryTickets(
            _ticketIds,
            _naffleId
        );
    }

    /**
     * @inheritdoc IL2NaffleBase
     */
    function ownerCancelNaffle(
        uint256 _naffleId
    ) external {
        _ownerCancelNaffle(
            _naffleId
        );
    }

    /**
     * @inheritdoc IL2NaffleBase
     */
    function ownerDrawWinner(uint256 _naffleId) external returns (bytes32) {
        return _ownerDrawWinner(
            _naffleId
        );
    }
}
