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

export interface IL2OpenEntryTicketBaseInternalInterface
  extends utils.Interface {
  functions: {};

  events: {
    "TicketDetachedFromNaffle(uint256,uint256,uint256,address)": EventFragment;
    "TicketsAttachedToNaffle(uint256,uint256[],uint256,address)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "TicketDetachedFromNaffle"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "TicketsAttachedToNaffle"): EventFragment;
}

export interface TicketDetachedFromNaffleEventObject {
  naffleId: BigNumber;
  ticketId: BigNumber;
  naffleTicketId: BigNumber;
  owner: string;
}
export type TicketDetachedFromNaffleEvent = TypedEvent<
  [BigNumber, BigNumber, BigNumber, string],
  TicketDetachedFromNaffleEventObject
>;

export type TicketDetachedFromNaffleEventFilter =
  TypedEventFilter<TicketDetachedFromNaffleEvent>;

export interface TicketsAttachedToNaffleEventObject {
  naffleId: BigNumber;
  ticketIds: BigNumber[];
  startingTicketId: BigNumber;
  owner: string;
}
export type TicketsAttachedToNaffleEvent = TypedEvent<
  [BigNumber, BigNumber[], BigNumber, string],
  TicketsAttachedToNaffleEventObject
>;

export type TicketsAttachedToNaffleEventFilter =
  TypedEventFilter<TicketsAttachedToNaffleEvent>;

export interface IL2OpenEntryTicketBaseInternal extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IL2OpenEntryTicketBaseInternalInterface;

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
    "TicketDetachedFromNaffle(uint256,uint256,uint256,address)"(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      ticketId?: null,
      naffleTicketId?: null,
      owner?: PromiseOrValue<string> | null
    ): TicketDetachedFromNaffleEventFilter;
    TicketDetachedFromNaffle(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      ticketId?: null,
      naffleTicketId?: null,
      owner?: PromiseOrValue<string> | null
    ): TicketDetachedFromNaffleEventFilter;

    "TicketsAttachedToNaffle(uint256,uint256[],uint256,address)"(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      ticketIds?: null,
      startingTicketId?: null,
      owner?: PromiseOrValue<string> | null
    ): TicketsAttachedToNaffleEventFilter;
    TicketsAttachedToNaffle(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      ticketIds?: null,
      startingTicketId?: null,
      owner?: PromiseOrValue<string> | null
    ): TicketsAttachedToNaffleEventFilter;
  };

  estimateGas: {};

  populateTransaction: {};
}