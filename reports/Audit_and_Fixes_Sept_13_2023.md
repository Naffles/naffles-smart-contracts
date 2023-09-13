Curion - Aug-Sept 2023
# Summary & Scope

The [naffles-smart-contracts](https://github.com/Naffles/naffles-smart-contracts) repository was audited at commit [43341b3aafe9f882b01991e548e789ae93b8159a](https://github.com/Naffles/naffles-smart-contracts/tree/43341b3aafe9f882b01991e548e789ae93b8159a)
The following contract folders and files were in scope (all within hardhat/contracts/):
1. naffle/
	1. ethereum/
		1. L1NaffleAdmin.sol
		2. L1NaffleBase.sol
		3. L1NaffleBaseInternal.sol
		4. L1NaffleBaseStorage.sol
		5. L1NaffleDiamond.sol
		6. L1NaffleView.sol
	2. zksync/
		1. L2NaffleAdmin.sol
		2. L2NaffleBase.sol
		3. L2NaffleBaseInternal.sol
		4. L2NaffleBaseStorage.sol
		5. L2NaffleDiamond.sol
		6. L2NaffleView.sol
2. staking/
	1. FoundersKeyStaking.sol
3. tokens/
	1. zksync/ticket/
		1. open_entry/
			1. L2OpenEntryTicketAdmin.sol
			2. L2OpenEntryTicketBase.sol
			3. L2OpenEntryTicketBaseInternal.sol
			4. L2OpenEntryTicketDiamond.sol
			5. L2OpenEntryTicketStorage.sol
			6. L2OpenEntryTicketView.sol
		2. paid/
			1. L2PaidTicketAdmin.sol
			2. L2PaidTicketBase.sol
			3. L2PaidTicketBaseInternal.sol
			4. L2PaidTicketDiamond.sol
			5. L2PaidTicketStorage.sol
			6. L2PaidTicketView.sol
	2. SoulboundFoundersKeys.sol
4. vrf/polygon/
	1. NaffleVRF.sol

### Overall Areas of Concern and Associated Risks

1. Fair/Reliable Drawing of Winner
	1. Requires a working backend to reliably detect events emitted from either 
	2. Risks
		1. Time-based event misordering: sell-out, get random, draw winner has to be only in this order
		2. Incomplete error handling for failed txns on backend getting VRF
	3. Possible Mitigation
2. L1<->L2 Messaging Reliability
	1. Is there any way that a L1 transaction that writes or reads L2 data will receive/write no data to the L2 and the transaction will still confirm?
		1. It does not seem so - if there is not proof of L2 message inclusion the function will not. However, this error will not be evident until 
3. EIP-2535-related exploits or incorrect implementation

Other things to watch out for:
1. Undesirable States
	1. Naffles that can be created but for which all other calls revert after raffle creation
		1. Contract that implements both ERC721 and ERC1155 interfaces and at worst could prevent the NFT from being transferred to winners after tickets are sold and a winner is drawn.
2. Can raffle outcomes be frontrun even with VRF? 
	1. Seems not, no drawing will proceed until after ticket sale or user permits naffle to finish, and the timing of the call to draw the winner is irrelevant to the randomness of the outcome.

# Summary of Findings

Bear with me, I'm guessing at which category each of these are to an extent!
- Unknown - worth mentioning to confirm a detail, not enough info to classify severity or find an exploit per se
- Critical — Impacts the safe functioning of a protocol.
- High — Centralization and logical errors that can lead to a loss of user funds or protocol control.
- Medium — Affects the performance or reliability of the platform.
- Low — Inefficient code that does not put the application’s security at risk. 
- Informational — Related to style or industry best practices.
- Possible Improvement - some ideas I had that may help simplify things and decrease number of moving parts

| Identifier | Title                                                                                                                       | Severity      | Fixed         |
| ---------- | --------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------- |
| [U-01]     | Possible advance knowledge of raffle outcome?                                                                               | Unknown       | No, Non-issue |
| [U-02]     | L1NaffleBaseInternal.sol: Both ERC721 and ERC1155 interfaces can be included in the same contract                           | Unknown       | Yes           |
| [H-01]     | L1NafflesBaseInternal.sol: Malicious NFT Contracts can result in ticket sales but a NFT that can't be transferred to winner | High          | No, non-issue |
| [H-02]     | L1NaffleBase or L1NaffleBaseInternal: msg.value checking                                                                    | High          | Provisionally |
| [L-01]     | L1NaffleBaseInternal.sol\/L2NaffleBaseStorage.sol: Could pack function inputs                                               | Low           | No, will be   |
| [L-02]     | L1NaffleBaseInternal.sol: AccessControlInternal is inherited but not used                                                   | Low           | Yes           |
| [L-03]     | FoundersKeyStaking.sol: Interactions before Effects                                                                         | Low           | Yes           |
| [L-04]     | FoundersKeyStaking.sol: User staking array length does not change                                                           | Low           | Yes           |
| [L-05]     | FoundersKeyStaking.sol: Could incorporate into diamond rather than supply a separate upgrade pattern                        | Low           | No, will not  |
| [I-01]     | Missing comments on various contracts                                                                                       | Informational | Yes           |
| [I-03]     | L2NaffleBaseInternal Line 374: Magic number                                                                                 | Informational | Yes           |
| [I-04]     | SoulboundFoundersKeys.sol: AccessControl can be replaced with just checking addresses                                       | Informational | No, will not  |
| [I-05]     | L2PaidTicketBase and L2PaidTicketInternal: misleading function name                                                         | Informational | Yes              |
# Findings
## [U-01] Possible advance knowledge of raffle outcome?

### Description
This is mainly to do with the backend - in the event a naffle is sold out, I don't see any risk of knowing outcome of naffle. If naffle is not sold out, just confirming that a winner should not be drawn until after the user's decision on whether to postpone or allow for a winner to be chosen. 
### Fix
Non-issue, no risk of this happening.

## [U-02]  L1NaffleBaseInternal.sol: Both ERC721 and ERC1155 interfaces can be included in the same contract

### Description
Functions `_createNaffle(), _setWinnerAndTransferNFT(), and _cancelNaffle()` of L1NaffleBaseInternal.sol assume any token in question implements only one type of interface. If both, the naffle defaults to ERC721. I think using both never happens, and if it does, that token will just be excluded from the platform. Just something I'm bringing to your attention since someone could make a mess creating an ERC1155 with ERC721 interfaces or vice versa, it's classified as such, in the protocol, then the transfer doesn't work. Perhaps a malicious contract the uses both interfaces could cause some unwanted interactions - I can't think of an exploit scenario, seems no funds will be stored on the contract, but it is an opening that can be closed.
### Recommendation
Either just note the assumption or explicitly handle the error of tokens that implement both interfaces and prevent such contracts from creating naffles and having access to contract functions. Starting on  Line 68:
### Fix
Added checks to ensure that ERC721 tokens don't support ERC1155 interfaces and vice versa as an added layer of confirming a token will not break the protocol.
```sol
NaffleTypes.TokenContractType tokenContractType;
if (IERC165(_ethTokenAddress).supportsInterface(ERC721_INTERFACE_ID) && !(IERC165(_ethTokenAddress).supportsInterface(ERC1155_INTERFACE_ID))) {
	tokenContractType = NaffleTypes.TokenContractType.ERC721;
	IERC721(_ethTokenAddress).transferFrom(msg.sender, address(this), _nftId);
} else if (IERC165(_ethTokenAddress).supportsInterface(ERC1155_INTERFACE_ID) && !(IERC165(_ethTokenAddress).supportsInterface(ERC721_INTERFACE_ID))) {
	tokenContractType = NaffleTypes.TokenContractType.ERC1155;
	IERC1155(_ethTokenAddress).safeTransferFrom(msg.sender,  address(this), _nftId, 1, bytes(""));
} else {
	revert InvalidTokenType();
}
```
## [H-01] L1NaffleBaseInternal.sol: Malicious NFT Contracts can result in ticket sales but a NFT that can't be transferred to winner

### Description
If a NFT contract which only allows transfers to naffles contracts but prevents the NFT from being transferred to the winner, this could result in wasted ticket sales and a hanging message on the L2 that can't be consumed on the L1 since the transfer reverts. I.e. the NFT trades as normal in all scenarios, gains popularity and FP, but there is a sneaky flag in the transfer function that can be set at any time that prevents the NFT from being transferred *from* the naffle contract. Then all the tickets sell, and the call to transfer the NFT to the winner will revert.
### Recommendation
Perhaps integrate a simulation of transferring that NFT to the winner and validating the NFT's transfer logic after the naffle is created, but before tickets for it are sold so that this situation can be prevented and that naffle can be blacklisted. This could be complicated as there are many ways to selectively prevent transfers - could use some invariant testing while fuzzing all the contract variables to see if changing any variable will result in transfers being blocked as a bit of statistical protection, or *sigh* require a manual review. Or, just tell users to "DYOR NFA all risk is on you, check the contract yourself before buying tickets", etc.
### Fix
NFT Collections will be whitelisted (assuming this means the contracts will be checked), making this a non-issue, as long as a proper audit of the contract being whitelisted ensures that no malicious behavior is implemented.
## [H-02] L1NaffleBase or L1NaffleBaseInternal: msg.value checking

### Description
`createNaffle()` in L1NaffleBase or `_createNaffle()` in L1NaffleBaseInternal do not check the msg.value supplied. If you'd like to charge a fee for naffle creation this would make it pay-as-you-wish. If this is just for gas, I don't think it poses any threat as all extra gas is sent to the msg.sender. Furthermore, if the L1 msg.value is too low, the L1 transaction will confirm, but the L2 will fail, which would be problematic for having a L1 naffle registered but not a L2.
### Recommendation
Followed up on this, msg.value has to be calculated off-chain, and all unused funds return to msg.sender anyway, so they could assign a value of 100 ETH if they wanted. The main problem is that if the L2 transaction fails because *not enough* msg.value is forwarded, the L1 transaction will confirm and the NFT will be transferred, but the L2 naffle will not exist. 
### Fix
Ideal: on-chain way to obtain current L2 gas and set a minimum.

Meh - probably the desired approach: Hard-code a very high gas price such that there is a very low chance the txn will ever fail, given that a refund is guaranteed.

Maybe fine but leaves a vulnerability: Ensure all naffles are created via frontend and appropriate msg.value is supplied always

For now, I've included a variable `minL2ForwardedGasForCreateNaffle` in the `L1Storage` contract which is used in `L1NaffleBaseInternal` to check the `msg.value`. I also included the error `InsufficientL2GasForwardedForCreateNaffle()` in `IL1NaffleBaseInternal` as part of the checks for `msg.value `in `_createNaffle()`

## [L-01] L1NaffleBaseInternal.sol: Could pack function inputs 

### Description
Starting from L1/L2NaffleBaseStorage.sol and carrying through the Internal/Base contracts that either write or view the layout.* data, all uints are uint256.
### Recommendation
If it makes sense could pack all function inputs as structs to reduce words required/save a bit of gas on function calls. Nbd but could bring non-negligible savings. See https://velvetshark.com/articles/max-int-values-in-solidity. Maybe:
	
```sol
//L1
struct Layout {
	address zkSyncAddress;
	address zkSyncNaffleContractAddress;
	address foundersKeyAddress;
	address foundersKeyPlaceholderAddress;
	>>>			
	uint16 numberOfNaffles;
	uint112 minimumNaffleDuration;
	uint16 minimumPaidTicketSpots;
	uint112 minimumPaidTicketPriceInWei;
	<<<
	mapping(uint256 => NaffleTypes.L1Naffle) naffles;
	mapping(uint256 => address) naffleWinner;
	mapping(uint256 => mapping(uint256 => bool)) isL2ToL1MessageProcessed;
}

//L2
struct Layout {
	address l1NaffleContractAddress;
	address l1MessengerContractAddress;
	address paidTicketContractAddress;
	address openEntryTicketContractAddress;
	// 100 = 1%
	uint16 openEntryTicketRatio;
	uint120 platformFee;
	uint120 maxPostponeTime;
	mapping(uint256 => NaffleTypes.L2Naffle) naffles;
	uint256 platformFeesAccumulated;
	mapping(uint256 => bool) naffleRandomNumberRequested;
    }
```

### Fix
Will forego this optimization until all functionality checks and tests are done with the existing uint256 use for all variables. Less confusion while working out the core functionality and security. Gas bad, but exploit worse.

## [L-02] L1NaffleBaseInternal.sol: AccessControlInternal is inherited but not used

### Recommendation
If the access control is not used, remove the import/inheritance

### Fix
Removed inheritance of AccessControlInternal, as the contract inherited this contract but didn't use any of it's functions

## [L-03] FoundersKeyStaking.sol: Interactions before Effects
### Description
State changes come after external calls in stake/unstake functions.
### Recommendation
If following Checks-Effects-Interactions strictly, state changes like deleting array elements should come before the external function calls. This will also require use of ReentrancyGuard, which I usually add everywhere regardless as a "just-in-case" to have the explicit error handling.
	
As an untested example, I switch the order around and add nonReentrant here in `stake()`, but the idea could apply to `unstake()` too:

```sol
function stake(uint16 _nftId, StakingPeriod _stakingPeriod) external whenNotPaused nonReentrant {
    //explicit checks for owner of nft
    if(IERC721A(SoulboundFoundersKeyAddress).ownerOf(_nftId) != msg.sender) revert WTF_BRO();
	
	StakeInfo memory stakeInfo = StakeInfo(_nftId, block.timestamp, _stakingPeriod);
	StakeInfo[] storage stakeInfoArray = userStakeInfo[msg.sender];
	uint index = stakeInfoArray.length;
	stakeInfoArray.push(stakeInfo);
	nftIdToIndex[_nftId] = index;

	FoundersKeyAddress.transferFrom(msg.sender, address(this), _nftId);       
	SoulboundFoundersKeyAddress.safeMint(msg.sender, _nftId);

	emit UserStaked(msg.sender, _nftId, block.timestamp, _stakingPeriod);

}
```

### Fix
Implemented CEI ordering and included nonReentrant just to be irrationally safe.
## [L-04] FoundersKeyStaking.sol: User staking array length does not change
### Description
in `unstake()` the array items are deleted, but the array length remains the same. I see some places where `userStakeInfo[user]` is iterated over, and think it's worth considering whether this throws anything off.
### Recommendation
If you would like to remove the array item from the array, could implement a function that removes the array item rather than resetting it to default value as `delete` does - like this approach that would work if order doesn't matter:

```sol
function removeArrayItem(uint index) public {
	StakeInfo[] memory thisStakeInfo = userStakeInfo[msg.sender];
	thisStakeInfo[index] = thisStakeInfo[thisStakeInfo.length - 1];
	thisStakeInfo.pop();
}
```

### Fix
Wrote logic similar to that above within the `unstake()` function, and also altered the nftIdToIndex mapping to reflect the swap. This will decrease the need for iterating through many loops and avoid "swiss-cheese" data.

## [L-05] FoundersKeyStaking.sol: Could incorporate into diamond rather than supply a separate upgrade pattern

### Description
Noticed that FoundersKeyStaking uses a UUPS pattern - could it help with managing best practices for upgrades to keep all contracts within the diamond so that the upgrade method would be the same for any aspect of the whole protocol? I'm still building understanding of what is and isn't possible with diamonds, but thought this was worth suggesting.
### Recommendation
Consider adding FoundersKeyStaking as a facet of the diamond of L1Naffles.

### Fix
Will forego this for now, given timeline, the effort is not worth the reward. Just have to be mindful of both of the considerations as far as security and upgrades for both diamond and uups type upgradeable contracts.
## [I-01] Missing comments on various contracts

### Description
L1 and L2 NaffleBaseStorage, NaffleDiamond, FoundersKeyStaking, SoulboundFoundersKeys, and NaffleVRF do not have comments.
### Recommendation
Create comments similarly to other contracts

### Fix
Comments added.


## [I-03] L2NaffleBaseInternal Line 374: Magic number

### Description
"10000" is not given context
### Recommendation
Define constant DENOMINATOR = 10000; for clarity

### Fix
Added `DENOMINATOR` variable in `L2NaffleBaseInternal`
## [I-04] SoulboundFoundersKeys.sol: AccessControl can be replaced with just checking address

### Description
AccessControl is inherited but only used to check that the msg.sender for `safeMint` and `burn` is the staking contract and to adjust staking contract address. Could maybe reduce deployment cost a little by adding a modifier to check that the sender address is the staking contract address instead and just checking that msg.sender is the owner for `setFoundersKeysAddress()`. Pretty inconsequential either way, and using standardized libraries always feels more secure too.
### Recommendation
```sol
modifier senderIsStakingContract() {
	if(msg.sender != address(FoundersKeysAddress)) revert CallerIsNotStakingContract();
	_;
}

...
address public owner;

constructor(...) ... {
	...
	owner = msg.sender;
}

function setFoundersKeysAddress(address _foundersKeysAddress) external {
	if(msg.sender != owner) revert NotOwner();
	FoundersKeysAddress = IERC721A(_foundersKeysAddress);
}
```

### Fix
Leaving as is, negligible difference.

## [I-05] L2PaidTicketBase and L2PaidTicketInternal: misleading function name   

### Description, Recommendation, and Fix
`(_)refundAndBurnTickets` does not refund, the L2NaffleBaseInternal contract does the refunding, so clarify could be improved by renaming the function more clearly. Renamed function to `(_)burnTicketsBeforeRefund` in L2PaidTicketBase, IL2PaidTicketBase, L2PaidTicketBaseInternal, L2NaffleBaseInternal, and test_l2_paid_ticket_base.py
