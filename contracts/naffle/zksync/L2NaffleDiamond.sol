// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@solidstate/contracts/access/access_control/AccessControlStorage.sol";
import "@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "./L2NaffleBaseInternal.sol";

contract L2NaffleDiamond is SolidStateDiamond, AccessControl, L2NaffleBaseInternal {
    constructor(
        address _admin,
        uint256 _platformFee,
        uint256 _openEntryRatio,
        address _l1MessengerContractAddress,
        address _l1NaffleContractAddress,
        address _paidTicketContractAddress,
        address _openEntryTicketContractAddress,
        address _l1StakingContractAddress,
        uint256 _paidToOpenEntryBurnAmount,
        uint256 _paidToOpenEntryRedeemAmount,
        uint256[] memory _stakingMultipliersForOETicketRedeem
    ) SolidStateDiamond() {
        _grantRole(_getAdminRole(), _admin);
        _grantRole(VRF_ROLE, _admin);
        _setPlatformFee(_platformFee);
        _setOpenEntryRatio(_openEntryRatio);
        _setL1MessengerContractAddress(_l1MessengerContractAddress);
        _setPaidTicketContractAddress(_paidTicketContractAddress);
        _setOpenEntryTicketContractAddress(_openEntryTicketContractAddress);
        _setL1NaffleContractAddress(_l1NaffleContractAddress);
        _setL1StakingContractAddress(_l1StakingContractAddress);
        _setPaidToOpenEntryBurnAmount(_paidToOpenEntryBurnAmount);
        _setPaidToOpenEntryRedeemAmount(_paidToOpenEntryRedeemAmount);
        _setStakingMultipliersForOETicketRedeem(_stakingMultipliersForOETicketRedeem);
    }
}