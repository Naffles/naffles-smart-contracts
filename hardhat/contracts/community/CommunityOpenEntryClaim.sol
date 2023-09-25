//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

//this contract uses signatures to allow users from selected communities to claim open entry tickets

import "@openzeppelin/contracts/access/Ownable.sol";
import { SignatureChecker } from "../libraries/SignatureChecker.sol";
import { IL2OpenEntryTicketAdmin } from "../interfaces/IL2OpenEntryTicketAdmin.sol";

contract CommunityOpenEntryClaim is Ownable {

    IL2OpenEntryTicketAdmin public openEntryTicketAdmin;

    error InvalidSignature();

    constructor(address _openEntryTicketAdmin) {
        openEntryTicketAdmin = IL2OpenEntryTicketAdmin(_openEntryTicketAdmin);
    }

    /**
     * @notice claim open entry tickets for community promotion, validated by signature
     * @dev signature validates recipient and amount, and chain ID, signed by an admin wallet
     */
    function claimOpenEntryTicketViaCommunityPromotion(
        address _recipient,
        uint256 _amount,
        bytes _signature
    ) external {
            bool isValidSignature = SignatureChecker.isValidSignatureNow(
                _recipient,
                _amount,
                _signature,
                block.chainid
            );

            if(!isValidSignature){
                revert InvalidSignature();
            }

            openEntryTicketAdmin.adminMint(_recipient, _amount);
    }

}