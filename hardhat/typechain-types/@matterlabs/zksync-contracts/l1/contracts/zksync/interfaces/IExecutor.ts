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
} from "../../../../../../common";

export declare namespace IExecutor {
  export type StoredBlockInfoStruct = {
    blockNumber: PromiseOrValue<BigNumberish>;
    blockHash: PromiseOrValue<BytesLike>;
    indexRepeatedStorageChanges: PromiseOrValue<BigNumberish>;
    numberOfLayer1Txs: PromiseOrValue<BigNumberish>;
    priorityOperationsHash: PromiseOrValue<BytesLike>;
    l2LogsTreeRoot: PromiseOrValue<BytesLike>;
    timestamp: PromiseOrValue<BigNumberish>;
    commitment: PromiseOrValue<BytesLike>;
  };

  export type StoredBlockInfoStructOutput = [
    BigNumber,
    string,
    BigNumber,
    BigNumber,
    string,
    string,
    BigNumber,
    string
  ] & {
    blockNumber: BigNumber;
    blockHash: string;
    indexRepeatedStorageChanges: BigNumber;
    numberOfLayer1Txs: BigNumber;
    priorityOperationsHash: string;
    l2LogsTreeRoot: string;
    timestamp: BigNumber;
    commitment: string;
  };

  export type CommitBlockInfoStruct = {
    blockNumber: PromiseOrValue<BigNumberish>;
    timestamp: PromiseOrValue<BigNumberish>;
    indexRepeatedStorageChanges: PromiseOrValue<BigNumberish>;
    newStateRoot: PromiseOrValue<BytesLike>;
    numberOfLayer1Txs: PromiseOrValue<BigNumberish>;
    l2LogsTreeRoot: PromiseOrValue<BytesLike>;
    priorityOperationsHash: PromiseOrValue<BytesLike>;
    initialStorageChanges: PromiseOrValue<BytesLike>;
    repeatedStorageChanges: PromiseOrValue<BytesLike>;
    l2Logs: PromiseOrValue<BytesLike>;
    l2ArbitraryLengthMessages: PromiseOrValue<BytesLike>[];
    factoryDeps: PromiseOrValue<BytesLike>[];
  };

  export type CommitBlockInfoStructOutput = [
    BigNumber,
    BigNumber,
    BigNumber,
    string,
    BigNumber,
    string,
    string,
    string,
    string,
    string,
    string[],
    string[]
  ] & {
    blockNumber: BigNumber;
    timestamp: BigNumber;
    indexRepeatedStorageChanges: BigNumber;
    newStateRoot: string;
    numberOfLayer1Txs: BigNumber;
    l2LogsTreeRoot: string;
    priorityOperationsHash: string;
    initialStorageChanges: string;
    repeatedStorageChanges: string;
    l2Logs: string;
    l2ArbitraryLengthMessages: string[];
    factoryDeps: string[];
  };

  export type ProofInputStruct = {
    recursiveAggregationInput: PromiseOrValue<BigNumberish>[];
    serializedProof: PromiseOrValue<BigNumberish>[];
  };

  export type ProofInputStructOutput = [BigNumber[], BigNumber[]] & {
    recursiveAggregationInput: BigNumber[];
    serializedProof: BigNumber[];
  };
}

export interface IExecutorInterface extends utils.Interface {
  functions: {
    "commitBlocks((uint64,bytes32,uint64,uint256,bytes32,bytes32,uint256,bytes32),(uint64,uint64,uint64,bytes32,uint256,bytes32,bytes32,bytes,bytes,bytes,bytes[],bytes[])[])": FunctionFragment;
    "executeBlocks((uint64,bytes32,uint64,uint256,bytes32,bytes32,uint256,bytes32)[])": FunctionFragment;
    "proveBlocks((uint64,bytes32,uint64,uint256,bytes32,bytes32,uint256,bytes32),(uint64,bytes32,uint64,uint256,bytes32,bytes32,uint256,bytes32)[],(uint256[],uint256[]))": FunctionFragment;
    "revertBlocks(uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "commitBlocks"
      | "executeBlocks"
      | "proveBlocks"
      | "revertBlocks"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "commitBlocks",
    values: [IExecutor.StoredBlockInfoStruct, IExecutor.CommitBlockInfoStruct[]]
  ): string;
  encodeFunctionData(
    functionFragment: "executeBlocks",
    values: [IExecutor.StoredBlockInfoStruct[]]
  ): string;
  encodeFunctionData(
    functionFragment: "proveBlocks",
    values: [
      IExecutor.StoredBlockInfoStruct,
      IExecutor.StoredBlockInfoStruct[],
      IExecutor.ProofInputStruct
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "revertBlocks",
    values: [PromiseOrValue<BigNumberish>]
  ): string;

  decodeFunctionResult(
    functionFragment: "commitBlocks",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "executeBlocks",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "proveBlocks",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "revertBlocks",
    data: BytesLike
  ): Result;

  events: {
    "BlockCommit(uint256,bytes32,bytes32)": EventFragment;
    "BlockExecution(uint256,bytes32,bytes32)": EventFragment;
    "BlocksRevert(uint256,uint256,uint256)": EventFragment;
    "BlocksVerification(uint256,uint256)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "BlockCommit"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "BlockExecution"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "BlocksRevert"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "BlocksVerification"): EventFragment;
}

export interface BlockCommitEventObject {
  blockNumber: BigNumber;
  blockHash: string;
  commitment: string;
}
export type BlockCommitEvent = TypedEvent<
  [BigNumber, string, string],
  BlockCommitEventObject
>;

export type BlockCommitEventFilter = TypedEventFilter<BlockCommitEvent>;

export interface BlockExecutionEventObject {
  blockNumber: BigNumber;
  blockHash: string;
  commitment: string;
}
export type BlockExecutionEvent = TypedEvent<
  [BigNumber, string, string],
  BlockExecutionEventObject
>;

export type BlockExecutionEventFilter = TypedEventFilter<BlockExecutionEvent>;

export interface BlocksRevertEventObject {
  totalBlocksCommitted: BigNumber;
  totalBlocksVerified: BigNumber;
  totalBlocksExecuted: BigNumber;
}
export type BlocksRevertEvent = TypedEvent<
  [BigNumber, BigNumber, BigNumber],
  BlocksRevertEventObject
>;

export type BlocksRevertEventFilter = TypedEventFilter<BlocksRevertEvent>;

export interface BlocksVerificationEventObject {
  previousLastVerifiedBlock: BigNumber;
  currentLastVerifiedBlock: BigNumber;
}
export type BlocksVerificationEvent = TypedEvent<
  [BigNumber, BigNumber],
  BlocksVerificationEventObject
>;

export type BlocksVerificationEventFilter =
  TypedEventFilter<BlocksVerificationEvent>;

export interface IExecutor extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IExecutorInterface;

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
    commitBlocks(
      _lastCommittedBlockData: IExecutor.StoredBlockInfoStruct,
      _newBlocksData: IExecutor.CommitBlockInfoStruct[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    executeBlocks(
      _blocksData: IExecutor.StoredBlockInfoStruct[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    proveBlocks(
      _prevBlock: IExecutor.StoredBlockInfoStruct,
      _committedBlocks: IExecutor.StoredBlockInfoStruct[],
      _proof: IExecutor.ProofInputStruct,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    revertBlocks(
      _newLastBlock: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  commitBlocks(
    _lastCommittedBlockData: IExecutor.StoredBlockInfoStruct,
    _newBlocksData: IExecutor.CommitBlockInfoStruct[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  executeBlocks(
    _blocksData: IExecutor.StoredBlockInfoStruct[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  proveBlocks(
    _prevBlock: IExecutor.StoredBlockInfoStruct,
    _committedBlocks: IExecutor.StoredBlockInfoStruct[],
    _proof: IExecutor.ProofInputStruct,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  revertBlocks(
    _newLastBlock: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    commitBlocks(
      _lastCommittedBlockData: IExecutor.StoredBlockInfoStruct,
      _newBlocksData: IExecutor.CommitBlockInfoStruct[],
      overrides?: CallOverrides
    ): Promise<void>;

    executeBlocks(
      _blocksData: IExecutor.StoredBlockInfoStruct[],
      overrides?: CallOverrides
    ): Promise<void>;

    proveBlocks(
      _prevBlock: IExecutor.StoredBlockInfoStruct,
      _committedBlocks: IExecutor.StoredBlockInfoStruct[],
      _proof: IExecutor.ProofInputStruct,
      overrides?: CallOverrides
    ): Promise<void>;

    revertBlocks(
      _newLastBlock: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {
    "BlockCommit(uint256,bytes32,bytes32)"(
      blockNumber?: PromiseOrValue<BigNumberish> | null,
      blockHash?: PromiseOrValue<BytesLike> | null,
      commitment?: PromiseOrValue<BytesLike> | null
    ): BlockCommitEventFilter;
    BlockCommit(
      blockNumber?: PromiseOrValue<BigNumberish> | null,
      blockHash?: PromiseOrValue<BytesLike> | null,
      commitment?: PromiseOrValue<BytesLike> | null
    ): BlockCommitEventFilter;

    "BlockExecution(uint256,bytes32,bytes32)"(
      blockNumber?: PromiseOrValue<BigNumberish> | null,
      blockHash?: PromiseOrValue<BytesLike> | null,
      commitment?: PromiseOrValue<BytesLike> | null
    ): BlockExecutionEventFilter;
    BlockExecution(
      blockNumber?: PromiseOrValue<BigNumberish> | null,
      blockHash?: PromiseOrValue<BytesLike> | null,
      commitment?: PromiseOrValue<BytesLike> | null
    ): BlockExecutionEventFilter;

    "BlocksRevert(uint256,uint256,uint256)"(
      totalBlocksCommitted?: null,
      totalBlocksVerified?: null,
      totalBlocksExecuted?: null
    ): BlocksRevertEventFilter;
    BlocksRevert(
      totalBlocksCommitted?: null,
      totalBlocksVerified?: null,
      totalBlocksExecuted?: null
    ): BlocksRevertEventFilter;

    "BlocksVerification(uint256,uint256)"(
      previousLastVerifiedBlock?: PromiseOrValue<BigNumberish> | null,
      currentLastVerifiedBlock?: PromiseOrValue<BigNumberish> | null
    ): BlocksVerificationEventFilter;
    BlocksVerification(
      previousLastVerifiedBlock?: PromiseOrValue<BigNumberish> | null,
      currentLastVerifiedBlock?: PromiseOrValue<BigNumberish> | null
    ): BlocksVerificationEventFilter;
  };

  estimateGas: {
    commitBlocks(
      _lastCommittedBlockData: IExecutor.StoredBlockInfoStruct,
      _newBlocksData: IExecutor.CommitBlockInfoStruct[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    executeBlocks(
      _blocksData: IExecutor.StoredBlockInfoStruct[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    proveBlocks(
      _prevBlock: IExecutor.StoredBlockInfoStruct,
      _committedBlocks: IExecutor.StoredBlockInfoStruct[],
      _proof: IExecutor.ProofInputStruct,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    revertBlocks(
      _newLastBlock: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    commitBlocks(
      _lastCommittedBlockData: IExecutor.StoredBlockInfoStruct,
      _newBlocksData: IExecutor.CommitBlockInfoStruct[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    executeBlocks(
      _blocksData: IExecutor.StoredBlockInfoStruct[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    proveBlocks(
      _prevBlock: IExecutor.StoredBlockInfoStruct,
      _committedBlocks: IExecutor.StoredBlockInfoStruct[],
      _proof: IExecutor.ProofInputStruct,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    revertBlocks(
      _newLastBlock: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}
