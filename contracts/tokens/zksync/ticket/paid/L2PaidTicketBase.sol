// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./L2PaidTicketInternal.sol";
import "@solidstate/contracts/access/access_control/AccessControl.sol";
import "../../../../../interfaces/tokens/zksync/ticket/paid/IL2PaidTicketBase.sol";

contract L2PaidTicketBase is IL2PaidTicketBase, L2PaidTicketBaseInternal, AccessControl {
}
