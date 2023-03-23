// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L1NaffleBaseStorage.sol";
import "../../libraries/NaffleTypes.sol";
import '@solidstate/contracts/interfaces/IERC165.sol';
import '@solidstate/contracts/interfaces/IERC721.sol';
import '@solidstate/contracts/interfaces/IERC1155.sol';
import "@zksync/contracts/l1/zksync/interfaces/IZkSync.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleBaseInternal.sol";
import "@zksync/contracts/l2/system-contracts/interfaces/IL1Messenger.sol";

abstract contract L1NaffleBaseInternal is IL1NaffleBaseInternal, AccessControlInternal {
    bytes4 internal constant ERC721_INTERFACE_ID = 0x80ac58cd;
    bytes4 internal constant ERC1155_INTERFACE_ID = 0xd9b67a26;

    function _createNaffle(
        address _ethTokenAddress,
        uint256 _nftId,
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime,
        NaffleTypes.NaffleType _naffleType
    ) internal returns (uint256 naffleId, bytes32 txHash) {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();

        if (
            IERC721(layout.foundersKeyAddress).balanceOf(msg.sender) == 0 &&
            IERC721(layout.foundersKeyPlaceholderAddress).balanceOf(msg.sender) == 0
        ) {
            revert NotAllowed();
        }

        if (_endTime < block.timestamp + layout.minimumNaffleDuration) {
            revert InvalidEndTime(_endTime);
        }

        ++layout.numberOfNaffles;
        naffleId = layout.numberOfNaffles;
        if (
            (_naffleType == NaffleTypes.NaffleType.UNLIMITED && _paidTicketSpots != 0) ||
            (_naffleType == NaffleTypes.NaffleType.STANDARD && _paidTicketSpots < layout.minimumPaidTicketSpots)
        ) {
            // Unlimited naffles don't have an upper limit on paid or free tickets.
            revert InvalidPaidTicketSpots(_paidTicketSpots);
        }

        NaffleTypes.TokenContractType tokenContractType;
        if (IERC165(_ethTokenAddress).supportsInterface(ERC721_INTERFACE_ID)) {
            tokenContractType = NaffleTypes.TokenContractType.ERC721;
            IERC721(_ethTokenAddress).transferFrom(msg.sender, address(this), _nftId);
        } else if (IERC165(_ethTokenAddress).supportsInterface(ERC1155_INTERFACE_ID)) {
            tokenContractType = NaffleTypes.TokenContractType.ERC1155;
            IERC1155(_ethTokenAddress).safeTransferFrom(msg.sender,  address(this), _nftId, 1, bytes(""));
        } else {
            revert InvalidTokenType();
        }

        layout.naffles[naffleId] = NaffleTypes.L1Naffle({
            tokenAddress: _ethTokenAddress,
            nftId: _nftId,
            naffleId: naffleId,
            owner: msg.sender,
            winner: address(0),
            nftClaimed: false,
            cancelled: false,
            naffleTokenType: tokenContractType
        });

        IZkSync zksync = IZkSync(layout.zkSyncAddress);
        NaffleTypes.CreateZkSyncNaffleParams memory params = NaffleTypes.CreateZkSyncNaffleParams({
            ethTokenAddress: _ethTokenAddress,
            owner: msg.sender,
            naffleId: naffleId,
            nftId: _nftId,
            paidTicketSpots: _paidTicketSpots,
            ticketPriceInWei: _ticketPriceInWei,
            endTime: _endTime,
            naffleType: _naffleType,
            naffleTokenType: tokenContractType
        });

        txHash = zksync.requestL2Transaction{value: msg.value}(
            layout.zkSyncNaffleContractAddress,
            0,
            abi.encodeWithSignature(
              "createNaffle((address, address, uint256, uint256, uint256, uint256, uint8))",
                params
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

    function _consumeMessageFromL2(
        address _zkSyncAddress,
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes memory _message,
        bytes32[] calldata _proof
    ) internal {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        if (layout.isL2ToL1MessageProcessed[_l2BlockNumber][_index]) {
            revert MessageAlreadyProcessed();
        }

        IZkSync zksync = IZkSync(layout.zkSyncAddress);

        L2Message memory message = L2Message({
            sender: layout.zkSyncNaffleContractAddress,
            data: _message,
            txNumberInBlock: _l2TxNumberInBlock
        });

        bool success = zksync.proveL2MessageInclusion(
            _l2BlockNumber,
            _index,
            message,
            _proof
        );
        if (!success) {
            revert FailedMessageInclusion();
        }
        layout.isL2ToL1MessageProcessed[_l2BlockNumber][_index] = true;

        _processL2Message(_message);
    }

    function _processL2Message(bytes memory _message) internal {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        (string memory action, uint256 naffleId) = abi.decode(_message, (string, uint256));

        if (keccak256(abi.encode(action)) == keccak256(abi.encode("cancel"))) {
            layout.naffles[naffleId].cancelled = true;
        } else {
            revert InvalidAction();
        }
    }

    function _claimNFT(uint256 _naffleId) internal {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        NaffleTypes.L1Naffle storage naffle = layout.naffles[_naffleId];

        if (naffle.tokenAddress == address(0)) {
            revert InvalidNaffleId(_naffleId);
        }

        if (naffle.nftClaimed) {
            revert NFTAlreadyClaimed();
        }

        if (
            naffle.cancelled && naffle.owner != msg.sender ||
            !naffle.cancelled && naffle.winner != msg.sender
        ) {
            revert NotAllowed();
        }

        naffle.nftClaimed = true;

        if (naffle.naffleTokenType == NaffleTypes.TokenContractType.ERC721) {
            IERC721(naffle.tokenAddress).transferFrom(address(this), msg.sender, naffle.nftId);
        } else { // can't be another type because we check this on creation.
            IERC1155(naffle.tokenAddress).safeTransferFrom(address(this), msg.sender, naffle.nftId, 1, bytes(""));
        }
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

    function _setMinimumPaidTicketPriceInWei(uint256 _minimumPaidTicketPriceInWei) internal {
        L1NaffleBaseStorage.layout().minimumPaidTicketPriceInWei = _minimumPaidTicketPriceInWei;
    }

    function _getMinimumPaidTicketPriceInWei() internal view returns (uint256) {
        return L1NaffleBaseStorage.layout().minimumPaidTicketPriceInWei;
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

    function _getL1MessengerAddress() internal view returns (address) {
        return L1NaffleBaseStorage.L1_MESSENGER_ADDRESS;
    }

    function _getNaffleById(uint256 _naffleId) public view returns (NaffleTypes.L1Naffle memory) {
        return L1NaffleBaseStorage.layout().naffles[_naffleId];
    }
}
