/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  Signer,
  utils,
} from "ethers";
import type { EventFragment } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../../../../../common";

export interface IL2PaidTicketBaseInternalInterface extends utils.Interface {
  functions: {};

  events: {
    "PaidTicketsMinted(address,uint256[],uint256,uint256,uint256)": EventFragment;
    "PaidTicketsRefundedAndBurned(address,uint256,uint256[],uint256[])": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "PaidTicketsMinted"): EventFragment;
  getEvent(
    nameOrSignatureOrTopic: "PaidTicketsRefundedAndBurned"
  ): EventFragment;
}

export interface PaidTicketsMintedEventObject {
  owner: string;
  ticketIds: BigNumber[];
  naffleId: BigNumber;
  ticketPriceInWei: BigNumber;
  startingTicketId: BigNumber;
}
export type PaidTicketsMintedEvent = TypedEvent<
  [string, BigNumber[], BigNumber, BigNumber, BigNumber],
  PaidTicketsMintedEventObject
>;

export type PaidTicketsMintedEventFilter =
  TypedEventFilter<PaidTicketsMintedEvent>;

export interface PaidTicketsRefundedAndBurnedEventObject {
  owner: string;
  naffleId: BigNumber;
  ticketIds: BigNumber[];
  ticketIdsOnNaffle: BigNumber[];
}
export type PaidTicketsRefundedAndBurnedEvent = TypedEvent<
  [string, BigNumber, BigNumber[], BigNumber[]],
  PaidTicketsRefundedAndBurnedEventObject
>;

export type PaidTicketsRefundedAndBurnedEventFilter =
  TypedEventFilter<PaidTicketsRefundedAndBurnedEvent>;

export interface IL2PaidTicketBaseInternal extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IL2PaidTicketBaseInternalInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {};

  callStatic: {};

  filters: {
    "PaidTicketsMinted(address,uint256[],uint256,uint256,uint256)"(
      owner?: PromiseOrValue<string> | null,
      ticketIds?: null,
      naffleId?: PromiseOrValue<BigNumberish> | null,
      ticketPriceInWei?: null,
      startingTicketId?: null
    ): PaidTicketsMintedEventFilter;
    PaidTicketsMinted(
      owner?: PromiseOrValue<string> | null,
      ticketIds?: null,
      naffleId?: PromiseOrValue<BigNumberish> | null,
      ticketPriceInWei?: null,
      startingTicketId?: null
    ): PaidTicketsMintedEventFilter;

    "PaidTicketsRefundedAndBurned(address,uint256,uint256[],uint256[])"(
      owner?: PromiseOrValue<string> | null,
      naffleId?: PromiseOrValue<BigNumberish> | null,
      ticketIds?: null,
      ticketIdsOnNaffle?: null
    ): PaidTicketsRefundedAndBurnedEventFilter;
    PaidTicketsRefundedAndBurned(
      owner?: PromiseOrValue<string> | null,
      naffleId?: PromiseOrValue<BigNumberish> | null,
      ticketIds?: null,
      ticketIdsOnNaffle?: null
    ): PaidTicketsRefundedAndBurnedEventFilter;
  };

  estimateGas: {};

  populateTransaction: {};
}
