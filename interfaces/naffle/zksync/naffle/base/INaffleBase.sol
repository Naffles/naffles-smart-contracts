// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { NaffleBaseStorage } from "../../../../../contracts/naffle/zksync/naffle/base/NaffleBaseStorage.sol";

interface INaffleBase {
    function buyTickets(uint256 _amount, uint256 _naffleId) external payable returns (uint256[] memory);
    function setPlatformFee(uint256 _platformFee) external;
    function getPlatformFee() external view returns (uint256);
    function setNafflePaidTicketContract(address _nafflePaidTicketContract) external;
    function createNaffle(address _owner, address _naffleAddress, uint256 _nftId, uint256 paidTicketSpots, uint256 _endTime, uint256 _ticketPriceInWei, NaffleBaseStorage.NaffleType _naffleType) external;
    function postponeNaffle(uint256 _naffleId, NaffleBaseStorage.PostponeTime _postponeTime) external;
    function cancelNaffle(uint256 _naffleId) external;
    function adminCancelNaffle(uint256 _naffleId) external;
    function getNaffleInfo(uint256 _naffleId) external; 
    function setFreeTicketRatio(uint256 _freeTicketRatio) external;
    function getFreeTicketRatio() external view returns (uint256);
    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external;
    function getMinimumNaffleDuration() external view returns (uint256);
    function getMinimumPaidTicketSpots() external view returns (uint256);
    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external;
}
