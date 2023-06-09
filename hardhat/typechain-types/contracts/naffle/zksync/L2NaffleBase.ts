/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PayableOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type {
  FunctionFragment,
  Result,
  EventFragment,
} from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../../../common";

export declare namespace NaffleTypes {
  export type CreateZkSyncNaffleParamsStruct = {
    ethTokenAddress: PromiseOrValue<string>;
    owner: PromiseOrValue<string>;
    naffleId: PromiseOrValue<BigNumberish>;
    nftId: PromiseOrValue<BigNumberish>;
    paidTicketSpots: PromiseOrValue<BigNumberish>;
    ticketPriceInWei: PromiseOrValue<BigNumberish>;
    endTime: PromiseOrValue<BigNumberish>;
    naffleType: PromiseOrValue<BigNumberish>;
    naffleTokenType: PromiseOrValue<BigNumberish>;
  };

  export type CreateZkSyncNaffleParamsStructOutput = [
    string,
    string,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    number,
    number
  ] & {
    ethTokenAddress: string;
    owner: string;
    naffleId: BigNumber;
    nftId: BigNumber;
    paidTicketSpots: BigNumber;
    ticketPriceInWei: BigNumber;
    endTime: BigNumber;
    naffleType: number;
    naffleTokenType: number;
  };
}

export interface L2NaffleBaseInterface extends utils.Interface {
  functions: {
    "buyTickets(uint256,uint256)": FunctionFragment;
    "createNaffle((address,address,uint256,uint256,uint256,uint256,uint256,uint8,uint8))": FunctionFragment;
    "getRoleAdmin(bytes32)": FunctionFragment;
    "grantRole(bytes32,address)": FunctionFragment;
    "hasRole(bytes32,address)": FunctionFragment;
    "ownerCancelNaffle(uint256)": FunctionFragment;
    "ownerDrawWinner(uint256)": FunctionFragment;
    "renounceRole(bytes32)": FunctionFragment;
    "revokeRole(bytes32,address)": FunctionFragment;
    "useOpenEntryTickets(uint256[],uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "buyTickets"
      | "createNaffle"
      | "getRoleAdmin"
      | "grantRole"
      | "hasRole"
      | "ownerCancelNaffle"
      | "ownerDrawWinner"
      | "renounceRole"
      | "revokeRole"
      | "useOpenEntryTickets"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "buyTickets",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "createNaffle",
    values: [NaffleTypes.CreateZkSyncNaffleParamsStruct]
  ): string;
  encodeFunctionData(
    functionFragment: "getRoleAdmin",
    values: [PromiseOrValue<BytesLike>]
  ): string;
  encodeFunctionData(
    functionFragment: "grantRole",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "hasRole",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "ownerCancelNaffle",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "ownerDrawWinner",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "renounceRole",
    values: [PromiseOrValue<BytesLike>]
  ): string;
  encodeFunctionData(
    functionFragment: "revokeRole",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "useOpenEntryTickets",
    values: [PromiseOrValue<BigNumberish>[], PromiseOrValue<BigNumberish>]
  ): string;

  decodeFunctionResult(functionFragment: "buyTickets", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "createNaffle",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getRoleAdmin",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "grantRole", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "hasRole", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "ownerCancelNaffle",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "ownerDrawWinner",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "renounceRole",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "revokeRole", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "useOpenEntryTickets",
    data: BytesLike
  ): Result;

  events: {
    "L2NaffleCancelled(uint256,bytes32)": EventFragment;
    "L2NaffleCreated(uint256,address,address,uint256,uint256,uint256,uint256,uint256,uint8,uint8)": EventFragment;
    "L2NaffleFinished(uint256,address,uint256,bytes32)": EventFragment;
    "OpenEntryTicketsUsed(uint256,address,uint256[])": EventFragment;
    "RoleAdminChanged(bytes32,bytes32,bytes32)": EventFragment;
    "RoleGranted(bytes32,address,address)": EventFragment;
    "RoleRevoked(bytes32,address,address)": EventFragment;
    "TicketsBought(uint256,address,uint256[],uint256)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "L2NaffleCancelled"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "L2NaffleCreated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "L2NaffleFinished"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "OpenEntryTicketsUsed"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "RoleAdminChanged"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "RoleGranted"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "RoleRevoked"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "TicketsBought"): EventFragment;
}

export interface L2NaffleCancelledEventObject {
  naffleId: BigNumber;
  messageHash: string;
}
export type L2NaffleCancelledEvent = TypedEvent<
  [BigNumber, string],
  L2NaffleCancelledEventObject
>;

export type L2NaffleCancelledEventFilter =
  TypedEventFilter<L2NaffleCancelledEvent>;

export interface L2NaffleCreatedEventObject {
  naffleId: BigNumber;
  owner: string;
  ethTokenAddress: string;
  nftId: BigNumber;
  paidTicketSpots: BigNumber;
  freeTicketSpots: BigNumber;
  ticketPriceInWei: BigNumber;
  endTime: BigNumber;
  naffleType: number;
  tokenContractType: number;
}
export type L2NaffleCreatedEvent = TypedEvent<
  [
    BigNumber,
    string,
    string,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    number,
    number
  ],
  L2NaffleCreatedEventObject
>;

export type L2NaffleCreatedEventFilter = TypedEventFilter<L2NaffleCreatedEvent>;

export interface L2NaffleFinishedEventObject {
  naffleId: BigNumber;
  winner: string;
  winningTicketIdOnNaffle: BigNumber;
  messageHash: string;
}
export type L2NaffleFinishedEvent = TypedEvent<
  [BigNumber, string, BigNumber, string],
  L2NaffleFinishedEventObject
>;

export type L2NaffleFinishedEventFilter =
  TypedEventFilter<L2NaffleFinishedEvent>;

export interface OpenEntryTicketsUsedEventObject {
  naffleId: BigNumber;
  owner: string;
  ticketIds: BigNumber[];
}
export type OpenEntryTicketsUsedEvent = TypedEvent<
  [BigNumber, string, BigNumber[]],
  OpenEntryTicketsUsedEventObject
>;

export type OpenEntryTicketsUsedEventFilter =
  TypedEventFilter<OpenEntryTicketsUsedEvent>;

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

export interface TicketsBoughtEventObject {
  naffleId: BigNumber;
  buyer: string;
  ticketIds: BigNumber[];
  ticketPriceInWei: BigNumber;
}
export type TicketsBoughtEvent = TypedEvent<
  [BigNumber, string, BigNumber[], BigNumber],
  TicketsBoughtEventObject
>;

export type TicketsBoughtEventFilter = TypedEventFilter<TicketsBoughtEvent>;

export interface L2NaffleBase extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: L2NaffleBaseInterface;

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

  functions: {
    buyTickets(
      _amount: PromiseOrValue<BigNumberish>,
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    createNaffle(
      _params: NaffleTypes.CreateZkSyncNaffleParamsStruct,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    getRoleAdmin(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    grantRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    hasRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    ownerCancelNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    ownerDrawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    renounceRole(
      role: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    revokeRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    useOpenEntryTickets(
      _ticketIds: PromiseOrValue<BigNumberish>[],
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  buyTickets(
    _amount: PromiseOrValue<BigNumberish>,
    _naffleId: PromiseOrValue<BigNumberish>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  createNaffle(
    _params: NaffleTypes.CreateZkSyncNaffleParamsStruct,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  getRoleAdmin(
    role: PromiseOrValue<BytesLike>,
    overrides?: CallOverrides
  ): Promise<string>;

  grantRole(
    role: PromiseOrValue<BytesLike>,
    account: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  hasRole(
    role: PromiseOrValue<BytesLike>,
    account: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<boolean>;

  ownerCancelNaffle(
    _naffleId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  ownerDrawWinner(
    _naffleId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  renounceRole(
    role: PromiseOrValue<BytesLike>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  revokeRole(
    role: PromiseOrValue<BytesLike>,
    account: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  useOpenEntryTickets(
    _ticketIds: PromiseOrValue<BigNumberish>[],
    _naffleId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    buyTickets(
      _amount: PromiseOrValue<BigNumberish>,
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    createNaffle(
      _params: NaffleTypes.CreateZkSyncNaffleParamsStruct,
      overrides?: CallOverrides
    ): Promise<void>;

    getRoleAdmin(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<string>;

    grantRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    hasRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<boolean>;

    ownerCancelNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    ownerDrawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    renounceRole(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<void>;

    revokeRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    useOpenEntryTickets(
      _ticketIds: PromiseOrValue<BigNumberish>[],
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {
    "L2NaffleCancelled(uint256,bytes32)"(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      messageHash?: null
    ): L2NaffleCancelledEventFilter;
    L2NaffleCancelled(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      messageHash?: null
    ): L2NaffleCancelledEventFilter;

    "L2NaffleCreated(uint256,address,address,uint256,uint256,uint256,uint256,uint256,uint8,uint8)"(
      naffleId?: null,
      owner?: PromiseOrValue<string> | null,
      ethTokenAddress?: PromiseOrValue<string> | null,
      nftId?: null,
      paidTicketSpots?: null,
      freeTicketSpots?: null,
      ticketPriceInWei?: null,
      endTime?: null,
      naffleType?: PromiseOrValue<BigNumberish> | null,
      tokenContractType?: null
    ): L2NaffleCreatedEventFilter;
    L2NaffleCreated(
      naffleId?: null,
      owner?: PromiseOrValue<string> | null,
      ethTokenAddress?: PromiseOrValue<string> | null,
      nftId?: null,
      paidTicketSpots?: null,
      freeTicketSpots?: null,
      ticketPriceInWei?: null,
      endTime?: null,
      naffleType?: PromiseOrValue<BigNumberish> | null,
      tokenContractType?: null
    ): L2NaffleCreatedEventFilter;

    "L2NaffleFinished(uint256,address,uint256,bytes32)"(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      winner?: null,
      winningTicketIdOnNaffle?: null,
      messageHash?: null
    ): L2NaffleFinishedEventFilter;
    L2NaffleFinished(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      winner?: null,
      winningTicketIdOnNaffle?: null,
      messageHash?: null
    ): L2NaffleFinishedEventFilter;

    "OpenEntryTicketsUsed(uint256,address,uint256[])"(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      owner?: PromiseOrValue<string> | null,
      ticketIds?: null
    ): OpenEntryTicketsUsedEventFilter;
    OpenEntryTicketsUsed(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      owner?: PromiseOrValue<string> | null,
      ticketIds?: null
    ): OpenEntryTicketsUsedEventFilter;

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

    "TicketsBought(uint256,address,uint256[],uint256)"(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      buyer?: PromiseOrValue<string> | null,
      ticketIds?: null,
      ticketPriceInWei?: null
    ): TicketsBoughtEventFilter;
    TicketsBought(
      naffleId?: PromiseOrValue<BigNumberish> | null,
      buyer?: PromiseOrValue<string> | null,
      ticketIds?: null,
      ticketPriceInWei?: null
    ): TicketsBoughtEventFilter;
  };

  estimateGas: {
    buyTickets(
      _amount: PromiseOrValue<BigNumberish>,
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    createNaffle(
      _params: NaffleTypes.CreateZkSyncNaffleParamsStruct,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    getRoleAdmin(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    grantRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    hasRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    ownerCancelNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    ownerDrawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    renounceRole(
      role: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    revokeRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    useOpenEntryTickets(
      _ticketIds: PromiseOrValue<BigNumberish>[],
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    buyTickets(
      _amount: PromiseOrValue<BigNumberish>,
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    createNaffle(
      _params: NaffleTypes.CreateZkSyncNaffleParamsStruct,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    getRoleAdmin(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    grantRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    hasRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    ownerCancelNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    ownerDrawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    renounceRole(
      role: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    revokeRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    useOpenEntryTickets(
      _ticketIds: PromiseOrValue<BigNumberish>[],
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}
