// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IL2NaffleAdmin {
    function setPlatformFee(uint256 _platformFee) external;
    function setOpenEntryRatio(uint256 _openEntryTicketRatio) external;
    function setAdmin(address _admin) external;
    function setL1NaffleContractAddress(address _l1NaffleContractAddress) external;
    function setPaidTicketContractAddress(address _paidTicketContractAddress) external;
    function setOpenEntryTicketContractAddress(address _openEntryTicketContractAddress) external;
    function adminCancelNaffle(uint256 _naffleId) external;
    function setL1MessengerContractAddress(address _l1MessengerContractAddress) external;
    function setMaxPostponeTime(uint256 _maxPostponeTime) external;
}