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
import type { FunctionFragment, Result } from "@ethersproject/abi";
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

export interface IL2NaffleBaseInterface extends utils.Interface {
  functions: {
    "buyTickets(uint256,uint256)": FunctionFragment;
    "createNaffle((address,address,uint256,uint256,uint256,uint256,uint256,uint8,uint8))": FunctionFragment;
    "drawWinner(uint256)": FunctionFragment;
    "ownerCancelNaffle(uint256)": FunctionFragment;
    "ownerDrawWinner(uint256)": FunctionFragment;
    "postponeNaffle(uint256,uint256)": FunctionFragment;
    "refundTicketsForNaffle(uint256,uint256[],uint256[],address)": FunctionFragment;
    "useOpenEntryTickets(uint256[],uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "buyTickets"
      | "createNaffle"
      | "drawWinner"
      | "ownerCancelNaffle"
      | "ownerDrawWinner"
      | "postponeNaffle"
      | "refundTicketsForNaffle"
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
    functionFragment: "drawWinner",
    values: [PromiseOrValue<BigNumberish>]
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
    functionFragment: "postponeNaffle",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "refundTicketsForNaffle",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>[],
      PromiseOrValue<BigNumberish>[],
      PromiseOrValue<string>
    ]
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
  decodeFunctionResult(functionFragment: "drawWinner", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "ownerCancelNaffle",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "ownerDrawWinner",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "postponeNaffle",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "refundTicketsForNaffle",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "useOpenEntryTickets",
    data: BytesLike
  ): Result;

  events: {};
}

export interface IL2NaffleBase extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IL2NaffleBaseInterface;

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

    drawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    ownerCancelNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    ownerDrawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    postponeNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _newEndTime: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    refundTicketsForNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _openEntryTicketIds: PromiseOrValue<BigNumberish>[],
      _paidTicketIds: PromiseOrValue<BigNumberish>[],
      _owner: PromiseOrValue<string>,
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

  drawWinner(
    _naffleId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  ownerCancelNaffle(
    _naffleId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  ownerDrawWinner(
    _naffleId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  postponeNaffle(
    _naffleId: PromiseOrValue<BigNumberish>,
    _newEndTime: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  refundTicketsForNaffle(
    _naffleId: PromiseOrValue<BigNumberish>,
    _openEntryTicketIds: PromiseOrValue<BigNumberish>[],
    _paidTicketIds: PromiseOrValue<BigNumberish>[],
    _owner: PromiseOrValue<string>,
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

    drawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    ownerCancelNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    ownerDrawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    postponeNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _newEndTime: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    refundTicketsForNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _openEntryTicketIds: PromiseOrValue<BigNumberish>[],
      _paidTicketIds: PromiseOrValue<BigNumberish>[],
      _owner: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    useOpenEntryTickets(
      _ticketIds: PromiseOrValue<BigNumberish>[],
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {};

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

    drawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    ownerCancelNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    ownerDrawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    postponeNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _newEndTime: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    refundTicketsForNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _openEntryTicketIds: PromiseOrValue<BigNumberish>[],
      _paidTicketIds: PromiseOrValue<BigNumberish>[],
      _owner: PromiseOrValue<string>,
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

    drawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    ownerCancelNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    ownerDrawWinner(
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    postponeNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _newEndTime: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    refundTicketsForNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _openEntryTicketIds: PromiseOrValue<BigNumberish>[],
      _paidTicketIds: PromiseOrValue<BigNumberish>[],
      _owner: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    useOpenEntryTickets(
      _ticketIds: PromiseOrValue<BigNumberish>[],
      _naffleId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}
