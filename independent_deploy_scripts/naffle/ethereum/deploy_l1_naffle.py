import argparse
import json
import os


import pathlib
from pathlib import Path

from eth_account import Account
from eth_account.signers.local import LocalAccount
from web3 import Web3
from zksync2.core.types import EthBlockParams
from zksync2.manage_contracts.contract_encoder_base import ContractEncoder
from zksync2.manage_contracts.nonce_holder import NonceHolder
from zksync2.manage_contracts.precompute_contract_deployer import PrecomputeContractDeployer
from zksync2.manage_contracts.zksync_contract import ZkSyncContract
from zksync2.module.module_builder import ZkSyncBuilder
from zksync2.signer.eth_signer import PrivateKeyEthSigner
from zksync2.transaction.transaction_builders import TxCreateContract

CURRENT_DIR = pathlib.Path(__file__).parent.resolve()
CONTRACT_JSON_LOCATION = '/../../../build/contracts/'

parser = argparse.ArgumentParser()
parser.add_argument('--pkey', dest='private_key', type=str, help='private key for the account', required=True)
parser.add_argument('--network', dest='network', type=str, help='the network to use', required=True)
args = parser.parse_args()


def generate_random_salt() -> bytes:
    return os.urandom(32)


def get_contract_json_path(name: str) -> Path:
    return Path(f"{CURRENT_DIR}{CONTRACT_JSON_LOCATION}{name}.json")


def get_contract_json(name: str) -> dict:
    p = Path(f"{CURRENT_DIR}{CONTRACT_JSON_LOCATION}{name}.json")
    with p.open(mode='r') as f:
        data = json.load(f)
        return data


def deploy():
    if args.network == 'goerli':
        zksync_network_url = "https://zksync2-testnet.zksync.dev"
        url_to_eth_network = "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"
    else:
        raise NotImplemented()

    zksync_web3 = ZkSyncBuilder.build(zksync_network_url)
    chain_id = zksync_web3.zksync.chain_id
    eth_web3 = Web3(Web3.HTTPProvider(url_to_eth_network))
    account: LocalAccount = Account.from_key(args.private_key)
    signer = PrivateKeyEthSigner(account, chain_id)

    random_salt = generate_random_salt()
    nonce = zksync_web3.zksync.get_transaction_count(account.address, EthBlockParams.PENDING.value)
    nonce_holder = NonceHolder(zksync_web3, account)
    deployment_nonce = nonce_holder.get_deployment_nonce(account.address)
    deployer = PrecomputeContractDeployer(zksync_web3)
    precomputed_address = deployer.compute_l2_create_address(account.address, deployment_nonce)
    diamond = get_contract_json("Counter")

    print(f"precomputed address: {precomputed_address}")

    gas_price = zksync_web3.zksync.gas_price
    create_contract = TxCreateContract(web3=zksync_web3,
                                       chain_id=chain_id,
                                       nonce=nonce,
                                       from_=account.address,
                                       gas_limit=0,
                                       gas_price=gas_price,
                                       bytecode=diamond['bytecode'],
                                       salt=random_salt)

    estimate_gas = web3.zksync.eth_estimate_gas(create_contract.tx)
    print(f"Fee for transaction is: {estimate_gas * gas_price}")

if __name__ == "__main__":
    deploy()
