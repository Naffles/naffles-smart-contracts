// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L1NaffleBaseStorage.sol";
import "../../libraries/NaffleTypes.sol";
import '@solidstate/contracts/interfaces/IERC165.sol';
import '@solidstate/contracts/interfaces/IERC721.sol';
import '@solidstate/contracts/interfaces/IERC1155.sol';
import "@matterlabs/zksync-contracts/l1/contracts/zksync/interfaces/IZkSync.sol";
import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/access/access_control/AccessControlInternal.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleBaseInternal.sol";
import "@matterlabs/zksync-contracts/l1/contracts/zksync/Storage.sol";

abstract contract L1NaffleBaseInternal is IL1NaffleBaseInternal, AccessControlInternal {
    bytes4 internal constant ERC721_INTERFACE_ID = 0x80ac58cd;
    bytes4 internal constant ERC1155_INTERFACE_ID = 0xd9b67a26;
    bytes32 internal constant VRF_ROLE = keccak256("VRF_MANAGER");

    /**
     * @notice create a new naffle. When the naffle is created, a message is sent to the L2 naffle contract.
     * @dev function gets called by someone who wants to start a naffle.
     * @dev if the owner does not have a founders key, the owner can't create a naffle and a NotAllowed error is thrown.
     * @dev if the naffle end time is less than the current time + the minimum naffle duration, an InvalidEndTime error is thrown.
     * @dev if the naffle type is unlimited and the paid ticket spots is not 0, an InvalidPaidTicketSpots error is thrown.
     * @dev if the naffle type is standard and the paid ticket spots is less than the minimum paid ticket spots, an InvalidPaidTicketSpots error is thrown.
     * @dev if the token type is not supported an InvalidTokenType error is thrown.
     * @dev if the naffle type is standard and the nft id is 0, an InvalidNftId error is thrown.
     * @param _ethTokenAddress the address of the token contract.
     * @param _nftId the id of the nft.
     * @param _paidTicketSpots the number of paid ticket spots.
     * @param _ticketPriceInWei the price of a ticket in wei.
     * @param _endTime the end time of the naffle.
     * @param _naffleType the type of the naffle.
     * @return naffleId the id of the naffle that is created.
     * @return txHash the hash of the transaction that is sent to the L2 naffle contract.
     */
    function _createNaffle(
        address _ethTokenAddress,
        uint256 _nftId,
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime,
        NaffleTypes.NaffleType _naffleType,
        NaffleTypes.L2MessageParams memory _l2MessageParams
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
            // Unlimited naffles don't have an upper limit on paid or open entry tickets.
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
            cancelled: false,
            naffleTokenType: tokenContractType
        });

        IZkSync zksync = IZkSync(layout.zkSyncAddress);
        bytes memory data = abi.encodeWithSignature(
            "createNaffle((address,address,uint256,uint256,uint256,uint256,uint256,uint8,uint8))",
            NaffleTypes.CreateZkSyncNaffleParams({
                ethTokenAddress: _ethTokenAddress,
                owner: msg.sender,
                naffleId: naffleId,
                nftId: _nftId,
                paidTicketSpots: _paidTicketSpots,
                ticketPriceInWei: _ticketPriceInWei,
                endTime: _endTime,
                naffleType: _naffleType,
                naffleTokenType: tokenContractType
            })
        );

        txHash = zksync.requestL2Transaction{value: msg.value}(
            layout.zkSyncNaffleContractAddress,
            0,
            data,
            _l2MessageParams.l2GasLimit,
            _l2MessageParams.l2GasPerPubdataByteLimit,
            new bytes[](0),
            msg.sender
        );

        emit L1NaffleCreated(naffleId, msg.sender, _ethTokenAddress, _nftId, _paidTicketSpots, _ticketPriceInWei, _endTime, _naffleType, tokenContractType);
    }

    /**
     * @notice set the winner of a naffle and transfer the NFT to that address.
     * @param _naffleId the id of the naffle.
     * @param _winner the address of the winner.
     */
    function _setWinnerAndTransferNFT(
        uint256 _naffleId,
        address _winner
    ) internal {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        NaffleTypes.L1Naffle storage naffle = layout.naffles[_naffleId];

        naffle.winner = _winner;
        if (naffle.naffleTokenType == NaffleTypes.TokenContractType.ERC721) {
            IERC721(naffle.tokenAddress).transferFrom(address(this), _winner, naffle.nftId);
        } else if (naffle.naffleTokenType == NaffleTypes.TokenContractType.ERC1155) {
            IERC1155(naffle.tokenAddress).safeTransferFrom(address(this), _winner, naffle.nftId, 1, bytes(""));
        }

        emit L1NaffleWinnerSet(_naffleId, _winner);
    }

    /**
     * @notice consumes a message from L2. Stores that the message has been processed.
     * @param _l2BlockNumber the block number of the L2 block.
     * @param _index the index of the message in the L2 block.
     * @param _l2TxNumberInBlock the transaction number in the L2 block.
     * @param _messageHash the hashed message send by L2
     * @param _message the message that is consumed.
     * @param _proof the proof of the message.
     */
    function _consumeMessageFromL2(
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes32 _messageHash,
        bytes memory _message,
        bytes32[] memory _proof
    ) internal {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        if (layout.isL2ToL1MessageProcessed[_l2BlockNumber][_index]) {
            revert MessageAlreadyProcessed();
        }

        if (keccak256(_message) != _messageHash) {
            revert FailedMessageInclusion();
        }

        IZkSync zksync = IZkSync(layout.zkSyncAddress);

        L2Message memory l2Message = L2Message({
            sender: layout.zkSyncNaffleContractAddress,
            data: _message,
            txNumberInBlock: _l2TxNumberInBlock
        });

        bool success = zksync.proveL2MessageInclusion(
            _l2BlockNumber,
            _index,
            l2Message,
            _proof
        );
        if (!success) {
            revert FailedMessageInclusion();
        }

        layout.isL2ToL1MessageProcessed[_l2BlockNumber][_index] = true;
    }

    /**
     * @notice cancels a naffle.
     * @param _naffleId the id of the naffle.
     */
    function _cancelNaffle(uint256 _naffleId) internal {
        L1NaffleBaseStorage.Layout storage layout = L1NaffleBaseStorage.layout();
        NaffleTypes.L1Naffle storage naffle = layout.naffles[_naffleId];

        naffle.cancelled = true;
        if (naffle.naffleTokenType == NaffleTypes.TokenContractType.ERC721) {
            IERC721(naffle.tokenAddress).transferFrom(address(this), naffle.owner, naffle.nftId);
        } else if (naffle.naffleTokenType == NaffleTypes.TokenContractType.ERC1155) {
            IERC1155(naffle.tokenAddress).safeTransferFrom(address(this), naffle.owner, naffle.nftId, 1, bytes(""));
        }

        emit L1NaffleCancelled(_naffleId);
    }

    /**
     * @notice gets the admin role.
     * @return adminRole the admin role.
     */
    function _getAdminRole() internal pure returns (bytes32 adminRole) {
        adminRole = AccessControlStorage.DEFAULT_ADMIN_ROLE;
    }

    /**
     * @notice gets the minimum naffle duration.
     * @return minimumNaffleDuration the minimum naffle duration.
     */
    function _getMinimumNaffleDuration() internal view returns (uint256 minimumNaffleDuration) {
        minimumNaffleDuration = L1NaffleBaseStorage.layout().minimumNaffleDuration;
    }

    /**
     * @notice sets the minimum naffle duration.
     * @param _minimumNaffleDuration the minimum naffle duration.
     */
    function _setMinimumNaffleDuration(uint256 _minimumNaffleDuration) internal {
        L1NaffleBaseStorage.layout().minimumNaffleDuration = _minimumNaffleDuration;
    }

    /**
     * @notice gets the minimum paid ticket spots.
     * @return minimumPaidTicketSpots the minimum paid ticket spots.
     */
    function _getMinimumPaidTicketSpots() internal view returns (uint256 minimumPaidTicketSpots) {
        minimumPaidTicketSpots = L1NaffleBaseStorage.layout().minimumPaidTicketSpots;
    }

    /**
     * @notice sets the minimum paid ticket spots
     * @param _minimumPaidTicketSpots the minimum paid ticket spots.
     */
    function _setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) internal {
        L1NaffleBaseStorage.layout().minimumPaidTicketSpots = _minimumPaidTicketSpots;
    }

    /**
     * @notice sets the minimum paid ticket price in wei.
     * @param _minimumPaidTicketPriceInWei the minimum paid ticket price in wei.
     */
    function _setMinimumPaidTicketPriceInWei(uint256 _minimumPaidTicketPriceInWei) internal {
        L1NaffleBaseStorage.layout().minimumPaidTicketPriceInWei = _minimumPaidTicketPriceInWei;
    }

    /**
     * @notice gets the minimum paid ticket price in wei.
     * @return minimumPaidTicketPriceInWei the minimum paid ticket price in wei.
     */
    function _getMinimumPaidTicketPriceInWei() internal view returns (uint256 minimumPaidTicketPriceInWei) {
        minimumPaidTicketPriceInWei = L1NaffleBaseStorage.layout().minimumPaidTicketPriceInWei;
    }

    /**
     * @notice sets the zkSync naffle contract address.
     * @param _zkSyncNaffleContractAddress the zkSync naffle contract address.
     */
    function _setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) internal {
        L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress = _zkSyncNaffleContractAddress;
    }

    /**
     * @notice gets the zkSync naffle contract address.
     * @return zkSyncNaffleContractAddress the zkSync naffle contract address.
     */
    function _getZkSyncNaffleContractAddress() internal view returns (address zkSyncNaffleContractAddress) {
        zkSyncNaffleContractAddress = L1NaffleBaseStorage.layout().zkSyncNaffleContractAddress;
    }

    /**
     * @notice sets the zkSync address.
     * @param _zkSyncAddress the zkSync address.
     */
    function _setZkSyncAddress(address _zkSyncAddress) internal {
        L1NaffleBaseStorage.layout().zkSyncAddress = _zkSyncAddress;
    }

    /**
     * @notice gets the zkSync address.
     * @return zkSyncAddress the zkSync address.
     */
    function _getZkSyncAddress() internal view returns (address zkSyncAddress) {
        zkSyncAddress = L1NaffleBaseStorage.layout().zkSyncAddress;
    }

    /**
     * @notice gets the founders key address.
     * @return foundersKeyAddress the founders key address.
     */
    function _getFoundersKeyAddress() internal view returns (address foundersKeyAddress) {
        foundersKeyAddress = L1NaffleBaseStorage.layout().foundersKeyAddress;
    }

    /**
     * @notice sets the founders key address.
     * @param _foundersKeyAddress the founders key address.
     */
    function _setFoundersKeyAddress(address _foundersKeyAddress) internal {
        L1NaffleBaseStorage.layout().foundersKeyAddress = _foundersKeyAddress;
    }

    /**
     * @notice sets the founders key placeholder address.
     * @param _foundersKeyPlaceholderAddress the founders key placeholder address.
     */
    function _setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) internal {
        L1NaffleBaseStorage.layout().foundersKeyPlaceholderAddress = _foundersKeyPlaceholderAddress;
    }

    /**
     * @notice gets the founders key placeholder address.
     * @return foundersKeyPlaceholderAddress the founders key placeholder address.
     */
    function _getFoundersKeyPlaceholderAddress() internal view returns (address foundersKeyPlaceholderAddress) {
        foundersKeyPlaceholderAddress = L1NaffleBaseStorage.layout().foundersKeyPlaceholderAddress;
    }

    /**
     * @notice gets the L1 messenger address.
     * @return l1MessengerAddress the L1 messenger address.
     */
    function _getL1MessengerAddress() internal pure returns (address l1MessengerAddress) {
        l1MessengerAddress = L1NaffleBaseStorage.L1_MESSENGER_ADDRESS;
    }

    /**
     * @notice gets the naffle by id.
     * @param _naffleId the id of the naffle.
     * @return naffle the naffle.
     */
    function _getNaffleById(uint256 _naffleId) internal view returns (NaffleTypes.L1Naffle memory naffle) {
        naffle = L1NaffleBaseStorage.layout().naffles[_naffleId];
    }

    /**
     * @notice get the naffle VRF address.
     * @return naffleVRFAddress the naffle VRF address.
     */
    function _getNaffleVRFAddress() internal view returns (address naffleVRFAddress) {
        naffleVRFAddress = L1NaffleBaseStorage.layout().naffleVRFAddress;
    }

    /**
     * @notice sets the naffle VRF address.
     * @param _naffleVRFAddress the naffle VRF address.
     */
    function _setNaffleVRFAddress(address _naffleVRFAddress) internal {
        L1NaffleBaseStorage.layout().naffleVRFAddress = _naffleVRFAddress;
    }
}
