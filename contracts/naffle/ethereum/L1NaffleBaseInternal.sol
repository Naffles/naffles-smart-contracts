// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./L1NaffleBaseStorage.sol";
import "../../libraries/NaffleTypes.sol";
import '@solidstate/contracts/interfaces/IERC165.sol';
import '@solidstate/contracts/interfaces/IERC721.sol';
import '@solidstate/contracts/interfaces/IERC1155.sol';

import "@zksync/contracts/l1/zksync/interfaces/IZkSync.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleBaseInternal.sol";


abstract contract L1NaffleBaseInternal is IL1NaffleBaseInternal {
    bytes4 internal constant ERC721_INTERFACE_ID = 0x80ac58cd;
    bytes4 internal constant ERC1155_INTERFACE_ID = 0xd9b67a26;

    function _createNaffle(
        NaffleTypes.CreateNaffleParams memory _params
    ) internal returns (uint256 naffleId, bytes32 txHash) {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        
        if (
            IERC721(layout.foundersKeyAddress).balanceOf(msg.sender) == 0 && 
            IERC721(layout.foundersKeyPlaceholderAddress).balanceOf(msg.sender) == 0
        ) {
            revert NotAllowed();
        }

        if (block.timestamp + layout.minimumNaffleDuration < _params._endTime) {
            revert InvalidEndTime(_params._endTime);
        }
         
        ++layout.numberOfNaffles;
        naffleId = layout.numberOfNaffles;

        if (
            (_params._naffleType == NaffleTypes.NaffleType.UNLIMITED && _params._paidTicketSpots != 0) ||
            _params._paidTicketSpots < layout.minimumPaidTicketSpots
        ) {
            // Unlimited naffles don't have an upper limit on paid or free tickets.
            revert InvalidPaidTicketSpots(_params._paidTicketSpots);
        }

        NaffleTypes.TokenContractType tokenContractType;
        if (IERC165(_params._ethTokenAddress).supportsInterface(ERC721_INTERFACE_ID)) {
            tokenContractType = NaffleTypes.TokenContractType.ERC721;
            IERC721(_params._ethTokenAddress).transferFrom(msg.sender, address(this), _params._nftId);
        } else if (IERC165(_params._ethTokenAddress).supportsInterface(ERC1155_INTERFACE_ID)) {
            tokenContractType = NaffleTypes.TokenContractType.ERC1155;
            IERC1155(_params._ethTokenAddress).safeTransferFrom(msg.sender,  address(this), _params._nftId, 1, bytes(""));
        } else {
            revert InvalidTokenType();
        }

        layout.naffles[naffleId] = NaffleTypes.L1Naffle({
            tokenAddress: _params._ethTokenAddress,
            nftId: _params._nftId,
            naffleId: naffleId,
            owner: _params._owner,
            winner: address(0),
            winnerClaimed: false,
            naffleTokenType: tokenContractType
        });

        IZkSync zksync = IZkSync(layout.zkSyncAddress);
        txHash = zksync.requestL2Transaction{value: msg.value}(
            layout.zkSyncNaffleContractAddress,
            0,
            abi.encodeWithSignature(
              "createNaffle(address, address, uint256, uint256, uint256, uint256, uint8)", 
              _params._ethTokenAddress,
              _params._owner,
              _params._nftId,
              _params._paidTicketSpots,
              _params._ticketPriceInWei,
              _params._endTime,
              tokenContractType
            ),
            // Gas limit
            10000,
            // gas price per pubdata byte
            800,
            // factory dependencies
            new bytes[](0),
            // refund address
            address(0)
        );
    }

    function _getAdminRole() internal view returns (bytes32) {
        return AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    function _getMinimumNaffleDuration() internal view returns (uint256) {
        return L1NaffleBaseStorage.layout().minimumNaffleDuration;
    }

    function _setMinimumNaffleDuration(uint256 _minimumNaffleDuration) internal {
        L1NaffleBaseStorage.layout().minimumNaffleDuration = _minimumNaffleDuration;
    }

    function _getMinimumPaidTicketSpots() internal view returns (uint256) {
        return L1NaffleBaseStorage.layout().minimumPaidTicketSpots;
    }

    function _setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) internal {
        L1NaffleBaseStorage.layout().minimumPaidTicketSpots = _minimumPaidTicketSpots;
    }

    function _setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) internal {
        L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress = _zkSyncNaffleContractAddress;
    }

    function _getZkSyncNaffleContractAddress() internal view returns (address) {
        return L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress;
    }

    function _setZkSyncAddress(address _zkSyncAddress) internal {
        L1NaffleBaseStorage.layout().zkSyncAddress = _zkSyncAddress;
    }

    function _getZkSyncAddress() internal view returns (address) {
        return L1NaffleBaseStorage.layout().zkSyncAddress;
    }

    function _getFoundersKeyAddress() internal view returns (address) {
        return L1NaffleBaseStorage.layout().foundersKeyAddress;
    }

    function _setFoundersKeyAddress(address _foundersKeyAddress) internal {
        L1NaffleBaseStorage.layout().foundersKeyAddress = _foundersKeyAddress;
    }

    function _setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) internal {
        L1NaffleBaseStorage.layout().foundersKeyPlaceholderAddress = _foundersKeyPlaceholderAddress;
    }

    function _getFoundersKeyPlaceholderAddress() internal view returns (address) {
        return L1NaffleBaseStorage.layout().foundersKeyPlaceholderAddress;
    }
}
