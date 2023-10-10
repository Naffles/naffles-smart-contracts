// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBaseInternal.sol";
import "@solidstate/contracts/interfaces/IERC1155.sol";
import "@solidstate/contracts/token/ERC1155/base/ERC1155BaseInternal.sol";
import "@solidstate/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol";
import "@solidstate/contracts/token/ERC1155/metadata/ERC1155MetadataStorage.sol";
import "../../../../../interfaces/naffle/zksync/IL2NaffleView.sol";
import "../../../../libraries/NaffleTypes.sol";


abstract contract L2PaidTicketBaseInternal is IL2PaidTicketBaseInternal, AccessControlInternal, ERC1155BaseInternal, ERC1155EnumerableInternal {

    /**
     * @notice mints tickets to an address for a specific naffle.
     * @param _to the address to mint the tickets to.
     * @param _amount the amount of tickets to mint.
     * @param _naffleId the id of the naffle.
     * @param _ticketPriceInWei the price of the ticket in wei.
     * @param startingTicketId the starting ticket id on the naffle.
     */
    function _mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 _ticketPriceInWei, uint256 startingTicketId) internal {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        _safeMint(_to, _naffleId, _amount, "");

        emit PaidTicketsMinted(_to, _naffleId, _ticketPriceInWei, startingTicketId, _amount);
    }

    /**
     * @notice refunds tickets and burns them.
     * @dev if the status of the naffle is not cancelled a NaffleNotCancelled error is thrown.
     * @dev if the ticket id is invalid an InvalidTicketId error is thrown.
     * @dev if the msg.sender is not the owner of the ticket a NotTicketOwner error is thrown.
     * @dev if the refund fails a RefundFailed error is thrown.
     * @param _naffleId the id of the naffle.
     * @param _owner the owner of the tickets.
     */
    function _refundAndBurnTickets(uint256 _naffleId, uint256 _amount, address _owner) internal {
        L2PaidTicketStorage.Layout storage l = L2PaidTicketStorage.layout();
        NaffleTypes.L2Naffle memory naffle = IL2NaffleView(_getL2NaffleContractAddress()).getNaffleById(_naffleId);

        if (naffle.status != NaffleTypes.NaffleStatus.CANCELLED) {
            revert NaffleNotCancelled(naffle.status);
        }

        if (_amount == 0) {
            return;
        }
 
        _burn(_owner, _naffleId, _amount);

        emit PaidTicketsRefundedAndBurned(_owner, _naffleId, _amount);
    }

    /**
     * @notice gets the admin role
     * @return adminRole the admin role.
     */
    function _getAdminRole() internal pure returns (bytes32 adminRole) {
        adminRole = AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    /**
     * @notice gets the L2 naffle contract address.
     * @return l2NaffleContractAddress the L2 naffle contract address.
     */
    function _getL2NaffleContractAddress() internal view returns (address l2NaffleContractAddress) {
        l2NaffleContractAddress = L2PaidTicketStorage.layout().l2NaffleContractAddress;
    }

    /**
     * @notice sets the L2 naffle contract address.
     * @param _l2NaffleContractAddress the L2 naffle contract address.
     */

    function _setL2NaffleContractAddress(address _l2NaffleContractAddress) internal {
        L2PaidTicketStorage.layout().l2NaffleContractAddress = _l2NaffleContractAddress;
    }

    /**
     * @inheritdoc ERC1155BaseInternal
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override (ERC1155BaseInternal, ERC1155EnumerableInternal) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
