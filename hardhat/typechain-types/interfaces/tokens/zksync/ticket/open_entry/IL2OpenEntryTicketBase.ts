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
} from "../../../../../common";

export interface IL2OpenEntryTicketBaseInterface extends utils.Interface {
  functions: {
    "attachToNaffle(uint256,uint256[],uint256,address)": FunctionFragment;
    "detachFromNaffle(uint256,uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic: "attachToNaffle" | "detachFromNaffle"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "attachToNaffle",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>[],
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "detachFromNaffle",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>]
  ): string;

  decodeFunctionResult(
    functionFragment: "attachToNaffle",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "detachFromNaffle",
    data: BytesLike
  ): Result;

  events: {};
}

export interface IL2OpenEntryTicketBase extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IL2OpenEntryTicketBaseInterface;

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
    attachToNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _ticketIds: PromiseOrValue<BigNumberish>[],
      startingTicketId: PromiseOrValue<BigNumberish>,
      owner: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    detachFromNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _naffleTicketId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  attachToNaffle(
    _naffleId: PromiseOrValue<BigNumberish>,
    _ticketIds: PromiseOrValue<BigNumberish>[],
    startingTicketId: PromiseOrValue<BigNumberish>,
    owner: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  detachFromNaffle(
    _naffleId: PromiseOrValue<BigNumberish>,
    _naffleTicketId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    attachToNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _ticketIds: PromiseOrValue<BigNumberish>[],
      startingTicketId: PromiseOrValue<BigNumberish>,
      owner: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    detachFromNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _naffleTicketId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {};

  estimateGas: {
    attachToNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _ticketIds: PromiseOrValue<BigNumberish>[],
      startingTicketId: PromiseOrValue<BigNumberish>,
      owner: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    detachFromNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _naffleTicketId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    attachToNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _ticketIds: PromiseOrValue<BigNumberish>[],
      startingTicketId: PromiseOrValue<BigNumberish>,
      owner: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    detachFromNaffle(
      _naffleId: PromiseOrValue<BigNumberish>,
      _naffleTicketId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}