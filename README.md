# naffles-smart-contracts

curion/naffl-384-add-feature-redeem-used-paid-tickets-for-open-entry-tickets

TODO: confirm steps, write tests (hardhat would be preferred)

1. added redeemOpenEntryTickets to L2NaffleBase
2. added _redeemOpenEntryTickets to L2NaffleBaseInternal
3. added redeemOpenEntryTickets to IL2NaffleBase
4. added InvalidPaidToOpenEntryRatio error to IL2NaffleBaseInternal
5. added burnUsedPaidTicketsBeforeRedeemingOpenEntryTickets to L2PaidTicketBase
6. added _burnUsedPaidTicketsBeforeRedeemingOpenEntryTickets to L2PaidTicketInternal
7. added way to get multiplier from stake duration directly in L2NaffleBaseInternal with constants
8. added userToStakedFoundersKeyIdsToStakeDuration and userToStakedFoundersKeyAmount to L2NaffleBaseStorage
9. added setUserToStakedFoundersKeyIdsToStakeDuration in L2NaffleBase/Internal and IL2NaffleBase (only callable by staking contract)
10. added l1StakingContractAddress to L2NaffleBaseStorage
11. added _setl1StakingContractAddress to L2NaffleBaseInternal and L2NaffleAdmin, then call in L2NaffleDiamond. this will ensure future calls that set staking info come only from the staking contract.
12. added getL1StakingContractAddress to L2NaffleBaseInternal, L2Naffle
13. Included logic in the staking contract to write to L2NaffleBaseStorage on both stake and unstake.
14. will add related view/admin functions - go back over steps and see what is missing, if this approach is stuck with
15. added logic in L2OpenEntryTicketBase to call _adminMint in L2OpenEntryTicketBaseInternal to mint new OE tickets when redeeming paid tickets
16. will add events to top level ticket redemption on L2NaffleBaseInternal

Review steps to make sure there's nothing missing - this was a brainful to map across all contracts

### Concerns
To redeem tickets on zksync according to a rate determined by the length of time a nft is staked on mainnet,
there has to be some means to read a L1 value from L2 OR upon staking for the L1 transaction to write data to the L2NaffleBaseStorage contract

I think the latter seems more feasible based on the zkSync docs I've read

--> adding userToStakedFoundersKeyIdsToStakeDuration to L2NaffleBaseStorage, which will be written to when a user stakes their NFT. The sorting of stake times to find the best will be done on zkSync to save on costs

Brainstorm: how to check protocol invariants??