//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/// @notice this contract uses signatures to allow users from selected communities to claim open entry tickets

import "@openzeppelin/contracts/access/Ownable.sol";
import { SignatureChecker } from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import { IL2OpenEntryTicketAdmin } from "../interfaces/IL2OpenEntryTicketAdmin.sol";

contract CommunityOpenEntryClaim is Ownable {

    IL2OpenEntryTicketAdmin public openEntryTicketAdmin;

    address private signer;

    mapping(address => uint256) public claimedTickets;

    error InvalidSignature();
    error TransactionWillExceedClaimMax();

    /**
     * @notice set the address of the L2OpenEntryTicketAdmin contract which calls adminMint
     * and set the signer address for signatures
     */
    constructor(
        address _openEntryTicketAdmin,
        address _signer
    ) {
        openEntryTicketAdmin = IL2OpenEntryTicketAdmin(_openEntryTicketAdmin);
        signer = _signer;
    }

    /**
     * @notice claim open entry tickets for community promotion, validated by signature
     * @dev signature validates recipient and amount, and chain ID, signed by an admin wallet
     */
    function claimOpenEntryTicketViaCommunityPromotion(
        address _recipient,
        uint256 _amount,
        uint256 _maxClaimable,
        bytes _signature
    ) external {
        bool isValidSignature =
            SignatureChecker.isValidSignatureNow(
                signer,
                ECDSA.toEthSignedMessageHash(
                    keccak256(
                        abi.encodePacked(
                            _recipient,
                            _maxClaimable
                            block.chainid
                        )
                    )
                ),
                _signature
            );

        if(!isValidSignature){
            revert InvalidSignature();
        }

        if(claimedTickets[_recipient] + _amount > _maxClaimable){
            revert TransactionWillExceedClaimMax();
        }

        openEntryTicketAdmin.adminMint(_recipient, _amount);
    }

}