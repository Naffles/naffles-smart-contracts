// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L1NaffleBaseInternal.sol";
import "../../../interfaces/naffle/ethereum/IL1NaffleAdmin.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "@solidstate/contracts/access/ownable/SafeOwnable.sol";

contract L1NaffleAdmin is IL1NaffleAdmin, L1NaffleBaseInternal, AccessControl, SafeOwnable {
    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external onlyRole(_getAdminRole()) {
        _setMinimumNaffleDuration(_minimumNaffleDuration);
    }

    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external onlyRole(_getAdminRole()) {
        _setMinimumPaidTicketSpots(_minimumPaidTicketSpots);
    }

    function setMinimumPaidTicketPriceInWei(uint256 _minimumPaidTicketPriceInWei) external onlyRole(_getAdminRole()) {
        _setMinimumPaidTicketPriceInWei(_minimumPaidTicketPriceInWei);
    }

    function setZkSyncNaffleContractAddress(address _zksyncNaffleContractAddress) external onlyRole(_getAdminRole()) {
        _setZkSyncNaffleContractAddress(_zksyncNaffleContractAddress);
    }

    function setZkSyncAddress(address _zksyncAddress) external onlyRole(_getAdminRole()) {
        _setZkSyncAddress(_zksyncAddress);
    }

    function setFoundersKeyAddress(address _foundersKeyAddress) external onlyRole(_getAdminRole()) {
        _setFoundersKeyAddress(_foundersKeyAddress);
    }

    function setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) external onlyRole(_getAdminRole()) {
        _setFoundersKeyPlaceholderAddress(_foundersKeyPlaceholderAddress);
    }

    function setAdmin(address _admin) external onlyOwner {
        _grantRole(_getAdminRole(), _admin);
    }

    function consumeAdminCancelMessage(
        address _zkSyncAddress,
        uint256 _l2BlockNumber,
        uint256 _index,
        uint16 _l2TxNumberInBlock,
        bytes calldata _message,
        bytes32[] calldata _proof
    ) external onlyRole(_getAdminRole()) {
        _consumeMessageFromL2(
            _zkSyncAddress,
            _l2BlockNumber,
            _index,
            _l2TxNumberInBlock,
            _message,
            _proof
        );
        (string memory action, uint256 naffleId) = abi.decode(_message, (string, uint256));
        if (keccak256(abi.encode(action)) == keccak256(abi.encode("cancel"))) {
            _cancelNaffle(naffleId);
        } else {
            revert InvalidAction();
        }
    }
}