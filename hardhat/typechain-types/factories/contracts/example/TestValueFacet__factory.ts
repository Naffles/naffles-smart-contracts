/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../common";
import type {
  TestValueFacet,
  TestValueFacetInterface,
} from "../../../contracts/example/TestValueFacet";

const _abi = [
  {
    inputs: [],
    name: "getValue",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "value",
        type: "string",
      },
    ],
    name: "setValue",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x0002000000000002000100000001035500000060011002700000004d0010019d0000008001000039000000400010043f0000000101200190000000350000c13d0000000001000031000000040110008c0000007a0000413d0000000101000367000000000101043b000000e0011002700000004f0210009c0000003d0000613d000000500110009c0000007a0000c13d0000000001000416000000000110004c0000007a0000c13d000000040100008a00000000011000310000005102000041000000000310004c000000000300001900000000030240190000005101100197000000000410004c000000000200a019000000510110009c00000000010300190000000001026019000000000110004c0000007a0000c13d0000005301000041000000000101041a000000010310019000000001021002700000007f0420018f00000000020460190000001f0420008c00000000040000190000000104002039000000010440018f000000000443004b0000007c0000613d000000570100004100000000001004350000002201000039000000040010043f000000580100004100000132000104300000000001000416000000000110004c0000007a0000c13d0000002001000039000001000010044300000120000004430000004e01000041000001310001042e0000000001000416000000000110004c0000007a0000c13d0000000001000031000000040210008a0000005103000041000000200420008c000000000400001900000000040340190000005102200197000000000520004c000000000300a019000000510220009c00000000020400190000000002036019000000000220004c0000007a0000c13d00000001020003670000000403200370000000000503043b000000520350009c0000007a0000213d00000023035000390000005104000041000000000613004b0000000006000019000000000604801900000051011001970000005103300197000000000713004b0000000004008019000000000113013f000000510110009c00000000010600190000000001046019000000000110004c0000007a0000c13d0000000401500039000000000112034f000000000201043b000000520120009c0000009c0000213d0000003f01200039000000200300008a000000000431016f000000400100043d0000000004410019000000000614004b00000000060000190000000106004039000000520740009c0000009c0000213d00000001066001900000009c0000c13d000000400040043f0000000004210436000000240650003900000000056200190000000007000031000000000575004b000000c00000a13d00000000010000190000013200010430000000800020043f000000000330004c000000900000613d00000053010000410000000000100435000000a001000039000000000320004c000000a20000613d000000540100004100000000040000190000000003040019000000000401041a000000a005300039000000000045043500000001011000390000002004300039000000000524004b000000860000413d000000c001300039000000960000013d000001000300008a000000000131016f000000a00010043f000000000120004c000000c001000039000000a0010060390000001f01100039000000200200008a000000000121016f0000005502100041000000560220009c000000a20000213d000000570100004100000000001004350000004101000039000000040010043f00000058010000410000013200010430000000400010043f00000020020000390000000003210436000000800200043d00000000002304350000004003100039000000000420004c000000b20000613d00000000040000190000000005340019000000a006400039000000000606043300000000006504350000002004400039000000000524004b000000ab0000413d000000000332001900000000000304350000005f02200039000000200300008a000000000232016f0000004d030000410000004d0420009c00000000020380190000004d0410009c000000000103801900000040011002100000006002200210000000000112019f000001310001042e0000001f0520018f00000001066003670000000507200272000000cd0000613d00000000080000190000000509800210000000000a940019000000000996034f000000000909043b00000000009a04350000000108800039000000000978004b000000c50000413d000000000850004c000000dc0000613d0000000507700210000000000676034f00000000077400190000000305500210000000000807043300000000085801cf000000000858022f000000000606043b0000010005500089000000000656022f00000000055601cf000000000585019f0000000000570435000000000224001900000000000204350000000002010433000000520520009c0000009c0000213d0000005305000041000000000605041a000000010560019000000001056002700000007f0750018f00000000050760190000001f0750008c00000000070000190000000107002039000000000676013f00000001066001900000002f0000c13d000000200650008c000001000000413d0000001f06200039000000050660027000000054066000410000005407000041000000200820008c0000000006074019000000530700004100000000007004350000001f0550003900000005055002700000005405500041000000000756004b000001000000813d000000000006041b0000000106600039000000000756004b000000fc0000413d0000001f0520008c000001210000a13d00000053040000410000000000400435000000000532017000000054030000410000002004000039000001130000613d00000020040000390000005403000041000000000600001900000000071400190000000007070433000000000073041b000000200440003900000001033000390000002006600039000000000756004b0000010b0000413d000000000525004b0000011e0000813d0000000305200210000000f80550018f000000010600008a000000000556022f000000000565013f00000000011400190000000001010433000000000151016f000000000013041b000000010100003900000001032002100000012b0000013d000000000120004c0000000001000019000001250000613d00000000010404330000000303200210000000010400008a000000000334022f000000000343013f000000000331016f0000000101200210000000000113019f0000005302000041000000000012041b0000000001000019000001310001042e0000013000000432000001310001042e0000013200010430000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000002000000000000000000000000000000400000010000000000000000000000000000000000000000000000000000000000000000000000000093a0935200000000000000000000000000000000000000000000000000000000209652558000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fffffffffffffffff7bb98fc2195e88707e2dbfb704e0976fe25b152a118a5725d62d104f388c7f813d8ee6e820f551ac0550446c9fd4c0a003fdb6309751fea20433fcd01d6c3f7ffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff000000000000007f4e487b710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b4f2833b8e9b83a1af2a487ec4f1e118ae7980da1c12e736ba0b1b3cb72806e9";

type TestValueFacetConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: TestValueFacetConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class TestValueFacet__factory extends ContractFactory {
  constructor(...args: TestValueFacetConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<TestValueFacet> {
    return super.deploy(overrides || {}) as Promise<TestValueFacet>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): TestValueFacet {
    return super.attach(address) as TestValueFacet;
  }
  override connect(signer: Signer): TestValueFacet__factory {
    return super.connect(signer) as TestValueFacet__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): TestValueFacetInterface {
    return new utils.Interface(_abi) as TestValueFacetInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): TestValueFacet {
    return new Contract(address, _abi, signerOrProvider) as TestValueFacet;
  }
}
