// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2OpenEntryTicketERC721AInternal.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
//import "@solidstate/contracts/token/ERC721/SolidStateERC721.sol";
//import "@solidstate/contracts/token/ERC721/base/ERC721BaseInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/open_entry/IL2OpenEntryTicketBase.sol";

contract L2OpenEntryTicketBase is IL2OpenEntryTicketBase, L2OpenEntryTicketERC721AInternal, AccessControl {
     modifier onlyL2NaffleContract() {
        if (msg.sender != _getL2NaffleContractAddress()) {
            revert NotAllowed();
        }
        _;
    }

    /**
     * @inheritdoc IL2OpenEntryTicketBase
     */
    function detachFromNaffle(uint256 _naffleId, uint256[] memory _naffleTicketIds) external onlyL2NaffleContract {
        _detachFromNaffle(_naffleId, _naffleTicketIds);
    }

    /**
     * @inheritdoc IL2OpenEntryTicketBase
     */
    function attachToNaffle(uint256 _naffleId, uint256[] memory _ticketIds, uint256 startingTicketId, address owner) external onlyL2NaffleContract() {
        _attachToNaffle(_naffleId, _ticketIds, startingTicketId, owner);
    }

    /**
     * @inheritdoc IL2OpenEntryTicketBase
     */
    function mintOpenEntryTicketsForUser(address _to, uint256 _amount) external override onlyL2NaffleContract() {
        _adminMint(_to, _amount);
    }
    
    /**
     * @inheritdoc IL2OpenEntryTicketBase
     */
    function claimStakingRewards(
        uint256 _amount,
        bytes memory _signature
     ) external {
        _claimStakingRewards(
            _amount,
            _signature
        );
    }

    /**
     * @inheritdoc IL2OpenEntryTicketBase
     */
    function adminMint(address _to, uint256 _amount) external onlyRole(_getAdminRole()){
        _adminMint(_to, _amount);
    }
}
