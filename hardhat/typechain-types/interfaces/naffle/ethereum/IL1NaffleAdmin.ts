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
} from "../../../common";

export interface IL1NaffleAdminInterface extends utils.Interface {
  functions: {
    "setAdmin(address)": FunctionFragment;
    "setFoundersKeyAddress(address)": FunctionFragment;
    "setFoundersKeyPlaceholderAddress(address)": FunctionFragment;
    "setMinimumNaffleDuration(uint256)": FunctionFragment;
    "setMinimumPaidTicketPriceInWei(uint256)": FunctionFragment;
    "setMinimumPaidTicketSpots(uint256)": FunctionFragment;
    "setZkSyncAddress(address)": FunctionFragment;
    "setZkSyncNaffleContractAddress(address)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "setAdmin"
      | "setFoundersKeyAddress"
      | "setFoundersKeyPlaceholderAddress"
      | "setMinimumNaffleDuration"
      | "setMinimumPaidTicketPriceInWei"
      | "setMinimumPaidTicketSpots"
      | "setZkSyncAddress"
      | "setZkSyncNaffleContractAddress"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "setAdmin",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "setFoundersKeyAddress",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "setFoundersKeyPlaceholderAddress",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "setMinimumNaffleDuration",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setMinimumPaidTicketPriceInWei",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setMinimumPaidTicketSpots",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setZkSyncAddress",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "setZkSyncNaffleContractAddress",
    values: [PromiseOrValue<string>]
  ): string;

  decodeFunctionResult(functionFragment: "setAdmin", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setFoundersKeyAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setFoundersKeyPlaceholderAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setMinimumNaffleDuration",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setMinimumPaidTicketPriceInWei",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setMinimumPaidTicketSpots",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setZkSyncAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setZkSyncNaffleContractAddress",
    data: BytesLike
  ): Result;

  events: {};
}

export interface IL1NaffleAdmin extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IL1NaffleAdminInterface;

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
    setAdmin(
      _admin: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setFoundersKeyAddress(
      _foundersKeyAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setFoundersKeyPlaceholderAddress(
      _foundersKeyPlaceholderAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setMinimumNaffleDuration(
      _minimumNaffleDuration: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setMinimumPaidTicketPriceInWei(
      _minimumPaidTicketPriceInWei: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setMinimumPaidTicketSpots(
      _minimumPaidTicketSpots: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setZkSyncAddress(
      _zkSyncAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setZkSyncNaffleContractAddress(
      _zkSyncNaffleContractAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  setAdmin(
    _admin: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setFoundersKeyAddress(
    _foundersKeyAddress: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setFoundersKeyPlaceholderAddress(
    _foundersKeyPlaceholderAddress: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setMinimumNaffleDuration(
    _minimumNaffleDuration: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setMinimumPaidTicketPriceInWei(
    _minimumPaidTicketPriceInWei: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setMinimumPaidTicketSpots(
    _minimumPaidTicketSpots: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setZkSyncAddress(
    _zkSyncAddress: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setZkSyncNaffleContractAddress(
    _zkSyncNaffleContractAddress: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    setAdmin(
      _admin: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    setFoundersKeyAddress(
      _foundersKeyAddress: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    setFoundersKeyPlaceholderAddress(
      _foundersKeyPlaceholderAddress: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    setMinimumNaffleDuration(
      _minimumNaffleDuration: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setMinimumPaidTicketPriceInWei(
      _minimumPaidTicketPriceInWei: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setMinimumPaidTicketSpots(
      _minimumPaidTicketSpots: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setZkSyncAddress(
      _zkSyncAddress: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    setZkSyncNaffleContractAddress(
      _zkSyncNaffleContractAddress: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {};

  estimateGas: {
    setAdmin(
      _admin: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setFoundersKeyAddress(
      _foundersKeyAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setFoundersKeyPlaceholderAddress(
      _foundersKeyPlaceholderAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setMinimumNaffleDuration(
      _minimumNaffleDuration: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setMinimumPaidTicketPriceInWei(
      _minimumPaidTicketPriceInWei: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setMinimumPaidTicketSpots(
      _minimumPaidTicketSpots: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setZkSyncAddress(
      _zkSyncAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setZkSyncNaffleContractAddress(
      _zkSyncNaffleContractAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    setAdmin(
      _admin: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setFoundersKeyAddress(
      _foundersKeyAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setFoundersKeyPlaceholderAddress(
      _foundersKeyPlaceholderAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setMinimumNaffleDuration(
      _minimumNaffleDuration: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setMinimumPaidTicketPriceInWei(
      _minimumPaidTicketPriceInWei: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setMinimumPaidTicketSpots(
      _minimumPaidTicketSpots: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setZkSyncAddress(
      _zkSyncAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setZkSyncNaffleContractAddress(
      _zkSyncNaffleContractAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}
