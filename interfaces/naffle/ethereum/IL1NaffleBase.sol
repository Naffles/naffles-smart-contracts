// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../../../contracts/libraries/NaffleTypes.sol";

interface IL1NaffleBase {
    function createNaffle(
        address _ethTokenAddress, 
        address _owner,
        uint256 _nftId, 
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime, 
        NaffleTypes.NaffleType _naffleType
    ) external returns (uint256 naffleId, bytes32 txHash);
}
