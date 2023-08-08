import os
import shutil

def copy():
    # we want to copy all the files in the contract folder to hardhat/contracts
    root_dir = os.path.dirname(os.path.abspath(__file__))
    brownie_root = f"{root_dir}/.."
    brownie_contracts = f"{brownie_root}/contracts"
    for path, _, files in os.walk(brownie_contracts):
        new_path = path.replace(brownie_contracts, f"{root_dir}/contracts")
        os.makedirs(new_path, exist_ok=True)
        for file in files:
            shutil.copy(os.path.join(path, file), new_path)
    brownie_interfaces = f"{brownie_root}/interfaces"
    for path, _, files in os.walk(brownie_interfaces):
        new_path = path.replace(brownie_interfaces, f"{root_dir}/interfaces")
        os.makedirs(new_path, exist_ok=True)
        for file in files:
            shutil.copy(os.path.join(path, file), new_path)


if __name__ == "__main__":
    copy()