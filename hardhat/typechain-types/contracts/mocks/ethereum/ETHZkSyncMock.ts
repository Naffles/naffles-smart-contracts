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

export type L2LogStruct = {
  l2ShardId: PromiseOrValue<BigNumberish>;
  isService: PromiseOrValue<boolean>;
  txNumberInBlock: PromiseOrValue<BigNumberish>;
  sender: PromiseOrValue<string>;
  key: PromiseOrValue<BytesLike>;
  value: PromiseOrValue<BytesLike>;
};

export type L2LogStructOutput = [
  number,
  boolean,
  number,
  string,
  string,
  string
] & {
  l2ShardId: number;
  isService: boolean;
  txNumberInBlock: number;
  sender: string;
  key: string;
  value: string;
};

export type L2MessageStruct = {
  txNumberInBlock: PromiseOrValue<BigNumberish>;
  sender: PromiseOrValue<string>;
  data: PromiseOrValue<BytesLike>;
};

export type L2MessageStructOutput = [number, string, string] & {
  txNumberInBlock: number;
  sender: string;
  data: string;
};

export declare namespace IMailbox {
  export type L2CanonicalTransactionStruct = {
    txType: PromiseOrValue<BigNumberish>;
    from: PromiseOrValue<BigNumberish>;
    to: PromiseOrValue<BigNumberish>;
    gasLimit: PromiseOrValue<BigNumberish>;
    gasPerPubdataByteLimit: PromiseOrValue<BigNumberish>;
    maxFeePerGas: PromiseOrValue<BigNumberish>;
    maxPriorityFeePerGas: PromiseOrValue<BigNumberish>;
    paymaster: PromiseOrValue<BigNumberish>;
    nonce: PromiseOrValue<BigNumberish>;
    value: PromiseOrValue<BigNumberish>;
    reserved: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>
    ];
    data: PromiseOrValue<BytesLike>;
    signature: PromiseOrValue<BytesLike>;
    factoryDeps: PromiseOrValue<BigNumberish>[];
    paymasterInput: PromiseOrValue<BytesLike>;
    reservedDynamic: PromiseOrValue<BytesLike>;
  };

  export type L2CanonicalTransactionStructOutput = [
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    BigNumber,
    [BigNumber, BigNumber, BigNumber, BigNumber],
    string,
    string,
    BigNumber[],
    string,
    string
  ] & {
    txType: BigNumber;
    from: BigNumber;
    to: BigNumber;
    gasLimit: BigNumber;
    gasPerPubdataByteLimit: BigNumber;
    maxFeePerGas: BigNumber;
    maxPriorityFeePerGas: BigNumber;
    paymaster: BigNumber;
    nonce: BigNumber;
    value: BigNumber;
    reserved: [BigNumber, BigNumber, BigNumber, BigNumber];
    data: string;
    signature: string;
    factoryDeps: BigNumber[];
    paymasterInput: string;
    reservedDynamic: string;
  };
}

export interface ETHZkSyncMockInterface extends utils.Interface {
  functions: {
    "called()": FunctionFragment;
    "finalizeEthWithdrawal(uint256,uint256,uint16,bytes,bytes32[])": FunctionFragment;
    "l2TransactionBaseCost(uint256,uint256,uint256)": FunctionFragment;
    "proveL1ToL2TransactionStatus(bytes32,uint256,uint256,uint16,bytes32[],uint8)": FunctionFragment;
    "proveL2LogInclusion(uint256,uint256,(uint8,bool,uint16,address,bytes32,bytes32),bytes32[])": FunctionFragment;
    "proveL2MessageInclusion(uint256,uint256,(uint16,address,bytes),bytes32[])": FunctionFragment;
    "requestL2Transaction(address,uint256,bytes,uint256,uint256,bytes[],address)": FunctionFragment;
    "serializeL2Transaction(uint256,uint256,address,address,bytes,uint256,uint256,bytes[],uint256,address)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "called"
      | "finalizeEthWithdrawal"
      | "l2TransactionBaseCost"
      | "proveL1ToL2TransactionStatus"
      | "proveL2LogInclusion"
      | "proveL2MessageInclusion"
      | "requestL2Transaction"
      | "serializeL2Transaction"
  ): FunctionFragment;

  encodeFunctionData(functionFragment: "called", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "finalizeEthWithdrawal",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BytesLike>,
      PromiseOrValue<BytesLike>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "l2TransactionBaseCost",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "proveL1ToL2TransactionStatus",
    values: [
      PromiseOrValue<BytesLike>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BytesLike>[],
      PromiseOrValue<BigNumberish>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "proveL2LogInclusion",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      L2LogStruct,
      PromiseOrValue<BytesLike>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "proveL2MessageInclusion",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      L2MessageStruct,
      PromiseOrValue<BytesLike>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "requestL2Transaction",
    values: [
      PromiseOrValue<string>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BytesLike>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BytesLike>[],
      PromiseOrValue<string>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "serializeL2Transaction",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>,
      PromiseOrValue<string>,
      PromiseOrValue<BytesLike>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BytesLike>[],
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>
    ]
  ): string;

  decodeFunctionResult(functionFragment: "called", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "finalizeEthWithdrawal",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "l2TransactionBaseCost",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "proveL1ToL2TransactionStatus",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "proveL2LogInclusion",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "proveL2MessageInclusion",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "requestL2Transaction",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "serializeL2Transaction",
    data: BytesLike
  ): Result;

  events: {
    "EthWithdrawalFinalized(address,uint256)": EventFragment;
    "NewPriorityRequest(uint256,bytes32,uint64,tuple,bytes[])": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "EthWithdrawalFinalized"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "NewPriorityRequest"): EventFragment;
}

export interface EthWithdrawalFinalizedEventObject {
  to: string;
  amount: BigNumber;
}
export type EthWithdrawalFinalizedEvent = TypedEvent<
  [string, BigNumber],
  EthWithdrawalFinalizedEventObject
>;

export type EthWithdrawalFinalizedEventFilter =
  TypedEventFilter<EthWithdrawalFinalizedEvent>;

export interface NewPriorityRequestEventObject {
  txId: BigNumber;
  txHash: string;
  expirationTimestamp: BigNumber;
  transaction: IMailbox.L2CanonicalTransactionStructOutput;
  factoryDeps: string[];
}
export type NewPriorityRequestEvent = TypedEvent<
  [
    BigNumber,
    string,
    BigNumber,
    IMailbox.L2CanonicalTransactionStructOutput,
    string[]
  ],
  NewPriorityRequestEventObject
>;

export type NewPriorityRequestEventFilter =
  TypedEventFilter<NewPriorityRequestEvent>;

export interface ETHZkSyncMock extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: ETHZkSyncMockInterface;

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
    called(overrides?: CallOverrides): Promise<[boolean]>;

    finalizeEthWithdrawal(
      _l2BlockNumber: PromiseOrValue<BigNumberish>,
      _l2MessageIndex: PromiseOrValue<BigNumberish>,
      _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
      _message: PromiseOrValue<BytesLike>,
      _merkleProof: PromiseOrValue<BytesLike>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    l2TransactionBaseCost(
      _gasPrice: PromiseOrValue<BigNumberish>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    proveL1ToL2TransactionStatus(
      _l2TxHash: PromiseOrValue<BytesLike>,
      _l2BlockNumber: PromiseOrValue<BigNumberish>,
      _l2MessageIndex: PromiseOrValue<BigNumberish>,
      _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
      _merkleProof: PromiseOrValue<BytesLike>[],
      _status: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    proveL2LogInclusion(
      _blockNumber: PromiseOrValue<BigNumberish>,
      _index: PromiseOrValue<BigNumberish>,
      _log: L2LogStruct,
      _proof: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    proveL2MessageInclusion(
      _blockNumber: PromiseOrValue<BigNumberish>,
      _index: PromiseOrValue<BigNumberish>,
      _message: L2MessageStruct,
      _proof: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    requestL2Transaction(
      _contractL2: PromiseOrValue<string>,
      _l2Value: PromiseOrValue<BigNumberish>,
      _calldata: PromiseOrValue<BytesLike>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      _factoryDeps: PromiseOrValue<BytesLike>[],
      _refundRecipient: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    serializeL2Transaction(
      _txId: PromiseOrValue<BigNumberish>,
      _l2Value: PromiseOrValue<BigNumberish>,
      _sender: PromiseOrValue<string>,
      _contractAddressL2: PromiseOrValue<string>,
      _calldata: PromiseOrValue<BytesLike>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      _factoryDeps: PromiseOrValue<BytesLike>[],
      _toMint: PromiseOrValue<BigNumberish>,
      _refundRecipient: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[IMailbox.L2CanonicalTransactionStructOutput]>;
  };

  called(overrides?: CallOverrides): Promise<boolean>;

  finalizeEthWithdrawal(
    _l2BlockNumber: PromiseOrValue<BigNumberish>,
    _l2MessageIndex: PromiseOrValue<BigNumberish>,
    _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
    _message: PromiseOrValue<BytesLike>,
    _merkleProof: PromiseOrValue<BytesLike>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  l2TransactionBaseCost(
    _gasPrice: PromiseOrValue<BigNumberish>,
    _l2GasLimit: PromiseOrValue<BigNumberish>,
    _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  proveL1ToL2TransactionStatus(
    _l2TxHash: PromiseOrValue<BytesLike>,
    _l2BlockNumber: PromiseOrValue<BigNumberish>,
    _l2MessageIndex: PromiseOrValue<BigNumberish>,
    _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
    _merkleProof: PromiseOrValue<BytesLike>[],
    _status: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<boolean>;

  proveL2LogInclusion(
    _blockNumber: PromiseOrValue<BigNumberish>,
    _index: PromiseOrValue<BigNumberish>,
    _log: L2LogStruct,
    _proof: PromiseOrValue<BytesLike>[],
    overrides?: CallOverrides
  ): Promise<boolean>;

  proveL2MessageInclusion(
    _blockNumber: PromiseOrValue<BigNumberish>,
    _index: PromiseOrValue<BigNumberish>,
    _message: L2MessageStruct,
    _proof: PromiseOrValue<BytesLike>[],
    overrides?: CallOverrides
  ): Promise<boolean>;

  requestL2Transaction(
    _contractL2: PromiseOrValue<string>,
    _l2Value: PromiseOrValue<BigNumberish>,
    _calldata: PromiseOrValue<BytesLike>,
    _l2GasLimit: PromiseOrValue<BigNumberish>,
    _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
    _factoryDeps: PromiseOrValue<BytesLike>[],
    _refundRecipient: PromiseOrValue<string>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  serializeL2Transaction(
    _txId: PromiseOrValue<BigNumberish>,
    _l2Value: PromiseOrValue<BigNumberish>,
    _sender: PromiseOrValue<string>,
    _contractAddressL2: PromiseOrValue<string>,
    _calldata: PromiseOrValue<BytesLike>,
    _l2GasLimit: PromiseOrValue<BigNumberish>,
    _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
    _factoryDeps: PromiseOrValue<BytesLike>[],
    _toMint: PromiseOrValue<BigNumberish>,
    _refundRecipient: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<IMailbox.L2CanonicalTransactionStructOutput>;

  callStatic: {
    called(overrides?: CallOverrides): Promise<boolean>;

    finalizeEthWithdrawal(
      _l2BlockNumber: PromiseOrValue<BigNumberish>,
      _l2MessageIndex: PromiseOrValue<BigNumberish>,
      _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
      _message: PromiseOrValue<BytesLike>,
      _merkleProof: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<void>;

    l2TransactionBaseCost(
      _gasPrice: PromiseOrValue<BigNumberish>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    proveL1ToL2TransactionStatus(
      _l2TxHash: PromiseOrValue<BytesLike>,
      _l2BlockNumber: PromiseOrValue<BigNumberish>,
      _l2MessageIndex: PromiseOrValue<BigNumberish>,
      _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
      _merkleProof: PromiseOrValue<BytesLike>[],
      _status: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<boolean>;

    proveL2LogInclusion(
      _blockNumber: PromiseOrValue<BigNumberish>,
      _index: PromiseOrValue<BigNumberish>,
      _log: L2LogStruct,
      _proof: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<boolean>;

    proveL2MessageInclusion(
      _blockNumber: PromiseOrValue<BigNumberish>,
      _index: PromiseOrValue<BigNumberish>,
      _message: L2MessageStruct,
      _proof: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<boolean>;

    requestL2Transaction(
      _contractL2: PromiseOrValue<string>,
      _l2Value: PromiseOrValue<BigNumberish>,
      _calldata: PromiseOrValue<BytesLike>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      _factoryDeps: PromiseOrValue<BytesLike>[],
      _refundRecipient: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<string>;

    serializeL2Transaction(
      _txId: PromiseOrValue<BigNumberish>,
      _l2Value: PromiseOrValue<BigNumberish>,
      _sender: PromiseOrValue<string>,
      _contractAddressL2: PromiseOrValue<string>,
      _calldata: PromiseOrValue<BytesLike>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      _factoryDeps: PromiseOrValue<BytesLike>[],
      _toMint: PromiseOrValue<BigNumberish>,
      _refundRecipient: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<IMailbox.L2CanonicalTransactionStructOutput>;
  };

  filters: {
    "EthWithdrawalFinalized(address,uint256)"(
      to?: PromiseOrValue<string> | null,
      amount?: null
    ): EthWithdrawalFinalizedEventFilter;
    EthWithdrawalFinalized(
      to?: PromiseOrValue<string> | null,
      amount?: null
    ): EthWithdrawalFinalizedEventFilter;

    "NewPriorityRequest(uint256,bytes32,uint64,tuple,bytes[])"(
      txId?: null,
      txHash?: null,
      expirationTimestamp?: null,
      transaction?: null,
      factoryDeps?: null
    ): NewPriorityRequestEventFilter;
    NewPriorityRequest(
      txId?: null,
      txHash?: null,
      expirationTimestamp?: null,
      transaction?: null,
      factoryDeps?: null
    ): NewPriorityRequestEventFilter;
  };

  estimateGas: {
    called(overrides?: CallOverrides): Promise<BigNumber>;

    finalizeEthWithdrawal(
      _l2BlockNumber: PromiseOrValue<BigNumberish>,
      _l2MessageIndex: PromiseOrValue<BigNumberish>,
      _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
      _message: PromiseOrValue<BytesLike>,
      _merkleProof: PromiseOrValue<BytesLike>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    l2TransactionBaseCost(
      _gasPrice: PromiseOrValue<BigNumberish>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    proveL1ToL2TransactionStatus(
      _l2TxHash: PromiseOrValue<BytesLike>,
      _l2BlockNumber: PromiseOrValue<BigNumberish>,
      _l2MessageIndex: PromiseOrValue<BigNumberish>,
      _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
      _merkleProof: PromiseOrValue<BytesLike>[],
      _status: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    proveL2LogInclusion(
      _blockNumber: PromiseOrValue<BigNumberish>,
      _index: PromiseOrValue<BigNumberish>,
      _log: L2LogStruct,
      _proof: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    proveL2MessageInclusion(
      _blockNumber: PromiseOrValue<BigNumberish>,
      _index: PromiseOrValue<BigNumberish>,
      _message: L2MessageStruct,
      _proof: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    requestL2Transaction(
      _contractL2: PromiseOrValue<string>,
      _l2Value: PromiseOrValue<BigNumberish>,
      _calldata: PromiseOrValue<BytesLike>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      _factoryDeps: PromiseOrValue<BytesLike>[],
      _refundRecipient: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    serializeL2Transaction(
      _txId: PromiseOrValue<BigNumberish>,
      _l2Value: PromiseOrValue<BigNumberish>,
      _sender: PromiseOrValue<string>,
      _contractAddressL2: PromiseOrValue<string>,
      _calldata: PromiseOrValue<BytesLike>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      _factoryDeps: PromiseOrValue<BytesLike>[],
      _toMint: PromiseOrValue<BigNumberish>,
      _refundRecipient: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    called(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    finalizeEthWithdrawal(
      _l2BlockNumber: PromiseOrValue<BigNumberish>,
      _l2MessageIndex: PromiseOrValue<BigNumberish>,
      _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
      _message: PromiseOrValue<BytesLike>,
      _merkleProof: PromiseOrValue<BytesLike>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    l2TransactionBaseCost(
      _gasPrice: PromiseOrValue<BigNumberish>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    proveL1ToL2TransactionStatus(
      _l2TxHash: PromiseOrValue<BytesLike>,
      _l2BlockNumber: PromiseOrValue<BigNumberish>,
      _l2MessageIndex: PromiseOrValue<BigNumberish>,
      _l2TxNumberInBlock: PromiseOrValue<BigNumberish>,
      _merkleProof: PromiseOrValue<BytesLike>[],
      _status: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    proveL2LogInclusion(
      _blockNumber: PromiseOrValue<BigNumberish>,
      _index: PromiseOrValue<BigNumberish>,
      _log: L2LogStruct,
      _proof: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    proveL2MessageInclusion(
      _blockNumber: PromiseOrValue<BigNumberish>,
      _index: PromiseOrValue<BigNumberish>,
      _message: L2MessageStruct,
      _proof: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    requestL2Transaction(
      _contractL2: PromiseOrValue<string>,
      _l2Value: PromiseOrValue<BigNumberish>,
      _calldata: PromiseOrValue<BytesLike>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      _factoryDeps: PromiseOrValue<BytesLike>[],
      _refundRecipient: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    serializeL2Transaction(
      _txId: PromiseOrValue<BigNumberish>,
      _l2Value: PromiseOrValue<BigNumberish>,
      _sender: PromiseOrValue<string>,
      _contractAddressL2: PromiseOrValue<string>,
      _calldata: PromiseOrValue<BytesLike>,
      _l2GasLimit: PromiseOrValue<BigNumberish>,
      _l2GasPerPubdataByteLimit: PromiseOrValue<BigNumberish>,
      _factoryDeps: PromiseOrValue<BytesLike>[],
      _toMint: PromiseOrValue<BigNumberish>,
      _refundRecipient: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}
