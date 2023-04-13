/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
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
} from "../../../common";

export interface L1NaffleBaseInternalInterface extends utils.Interface {
  functions: {};

  events: {
    "L1NaffleCancelled(uint256)": EventFragment;
    "L1NaffleCreated(uint256,address,address,uint256,uint256,uint256,uint256,uint8,uint8)": EventFragment;
    "L1NaffleWinnerSet(uint256,address)": EventFragment;
    "RoleAdminChanged(bytes32,bytes32,bytes32)": EventFragment;
    "RoleGranted(bytes32,address,address)": EventFragment;
    "RoleRevoked(bytes32,address,address)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "L1NaffleCancelled"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "L1NaffleCreated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "L1NaffleWinnerSet"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "RoleAdminChanged"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "RoleGranted"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "RoleRevoked"): EventFragment;
}

export interface L1NaffleCancelledEventObject {
  naffleId: BigNumber;
}
export type L1NaffleCancelledEvent = TypedEvent<
  [BigNumber],
  L1NaffleCancelledEventObject
>;

export type L1NaffleCancelledEventFilter =
  TypedEventFilter<L1NaffleCancelledEvent>;

export interface L1NaffleCreatedEventObject {
  naffleId: BigNumber;
  owner: string;
  ethTokenAddress: string;
  nftId: BigNumber;
  paidTicketSpots: BigNumber;
  ticketPriceInWei: BigNumber;
  endTime: BigNumber;
  naffleType: number;
  tokenContractType: number;
}
export type L1NaffleCreatedEvent = TypedEvent<
  [
    BigNumber,
    string,
    string,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    number,
    number
  ],
  L1NaffleCreatedEventObject
>;

export type L1NaffleCreatedEventFilter = TypedEventFilter<L1NaffleCreatedEvent>;

export interface L1NaffleWinnerSetEventObject {
  naffleId: BigNumber;
  winner: string;
}
export type L1NaffleWinnerSetEvent = TypedEvent<
  [BigNumber, string],
  L1NaffleWinnerSetEventObject
>;

export type L1NaffleWinnerSetEventFilter =
  TypedEventFilter<L1NaffleWinnerSetEvent>;

export interface RoleAdminChangedEventObject {
  role: string;
  previousAdminRole: string;
  newAdminRole: string;
}
export type RoleAdminChangedEvent = TypedEvent<
  [string, string, string],
  RoleAdminChangedEventObject
>;

export type RoleAdminChangedEventFilter =
  TypedEventFilter<RoleAdminChangedEvent>;

export interface RoleGrantedEventObject {
  role: string;
  account: string;
  sender: string;
}
export type RoleGrantedEvent = TypedEvent<
  [string, string, string],
  RoleGrantedEventObject
>;

export type RoleGrantedEventFilter = TypedEventFilter<RoleGrantedEvent>;

export interface RoleRevokedEventObject {
  role: string;
  account: string;
  sender: string;
}
export type RoleRevokedEvent = TypedEvent<
  [string, string, string],
  RoleRevokedEventObject
>;

export type RoleRevokedEventFilter = TypedEventFilter<RoleRevokedEvent>;

export interface L1NaffleBaseInternal extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: L1NaffleBaseInternalInterface;

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
    "L1NaffleCancelled(uint256)"(naffleId?: null): L1NaffleCancelledEventFilter;
    L1NaffleCancelled(naffleId?: null): L1NaffleCancelledEventFilter;

    "L1NaffleCreated(uint256,address,address,uint256,uint256,uint256,uint256,uint8,uint8)"(
      naffleId?: null,
      owner?: PromiseOrValue<string> | null,
      ethTokenAddress?: PromiseOrValue<string> | null,
      nftId?: null,
      paidTicketSpots?: null,
      ticketPriceInWei?: null,
      endTime?: null,
      naffleType?: null,
      tokenContractType?: null
    ): L1NaffleCreatedEventFilter;
    L1NaffleCreated(
      naffleId?: null,
      owner?: PromiseOrValue<string> | null,
      ethTokenAddress?: PromiseOrValue<string> | null,
      nftId?: null,
      paidTicketSpots?: null,
      ticketPriceInWei?: null,
      endTime?: null,
      naffleType?: null,
      tokenContractType?: null
    ): L1NaffleCreatedEventFilter;

    "L1NaffleWinnerSet(uint256,address)"(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      winner?: PromiseOrValue<string> | null
    ): L1NaffleWinnerSetEventFilter;
    L1NaffleWinnerSet(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      winner?: PromiseOrValue<string> | null
    ): L1NaffleWinnerSetEventFilter;

    "RoleAdminChanged(bytes32,bytes32,bytes32)"(
      role?: PromiseOrValue<BytesLike> | null,
      previousAdminRole?: PromiseOrValue<BytesLike> | null,
      newAdminRole?: PromiseOrValue<BytesLike> | null
    ): RoleAdminChangedEventFilter;
    RoleAdminChanged(
      role?: PromiseOrValue<BytesLike> | null,
      previousAdminRole?: PromiseOrValue<BytesLike> | null,
      newAdminRole?: PromiseOrValue<BytesLike> | null
    ): RoleAdminChangedEventFilter;

    "RoleGranted(bytes32,address,address)"(
      role?: PromiseOrValue<BytesLike> | null,
      account?: PromiseOrValue<string> | null,
      sender?: PromiseOrValue<string> | null
    ): RoleGrantedEventFilter;
    RoleGranted(
      role?: PromiseOrValue<BytesLike> | null,
      account?: PromiseOrValue<string> | null,
      sender?: PromiseOrValue<string> | null
    ): RoleGrantedEventFilter;

    "RoleRevoked(bytes32,address,address)"(
      role?: PromiseOrValue<BytesLike> | null,
      account?: PromiseOrValue<string> | null,
      sender?: PromiseOrValue<string> | null
    ): RoleRevokedEventFilter;
    RoleRevoked(
      role?: PromiseOrValue<BytesLike> | null,
      account?: PromiseOrValue<string> | null,
      sender?: PromiseOrValue<string> | null
    ): RoleRevokedEventFilter;
  };

  estimateGas: {};

  populateTransaction: {};
}