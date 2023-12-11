// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketBaseInternal.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBase.sol";
import "@solidstate/contracts/token/ERC1155/SolidStateERC1155.sol";

contract L2PaidTicketBase is IL2PaidTicketBase, L2PaidTicketBaseInternal, SolidStateERC1155, AccessControl {
    modifier onlyL2NaffleContract() {
        if (msg.sender != _getL2NaffleContractAddress()) {
            revert NotAllowed();
        }
        _;
    }

    /**
     * @inheritdoc IL2PaidTicketBase
     */
    function mintTickets(address _to, uint256 _amount, uint256 _naffleId, uint256 ticketPriceInWei, uint256 startingTicketId) external onlyL2NaffleContract {
        _mintTickets(_to, _amount, _naffleId, ticketPriceInWei, startingTicketId);
    }

    /**
     * @inheritdoc IL2PaidTicketBase
     */
    function refundAndBurnTickets(uint256 _naffleId, uint256 _amount, address _owner) external onlyL2NaffleContract {
        _refundAndBurnTickets(_naffleId, _amount, _owner);
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
    ) internal virtual override (SolidStateERC1155, L2PaidTicketBaseInternal) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }


    /**
     * @inheritdoc IL2PaidTicketBase
     */
    function burnTickets(uint256[] calldata _naffleIds, uint256[] calldata _amounts, address _owner) external onlyL2NaffleContract {
        _burnBatch(_owner, _naffleIds, _amounts);
    }
}
