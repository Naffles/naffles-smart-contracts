import os
import shutil


def replace_import_statement(file_path):
    """
    Replace the import statement in the smart contract file.
    """
    with open(file_path, 'r') as file:
        content = file.read()
        # Replace the import statement
        content = content.replace(
            '@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol',
            '@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol'
        )
    with open(file_path, 'w') as file:
        file.write(content)


def copy():
    # we want to copy all the files in the contract folder to hardhat/contracts
    root_dir = os.path.dirname(os.path.abspath(__file__))
    brownie_root = f"{root_dir}/.."
    brownie_contracts = f"{brownie_root}/contracts"
    for path, _, files in os.walk(brownie_contracts):
        new_path = path.replace(brownie_contracts, f"{root_dir}/contracts")
        os.makedirs(new_path, exist_ok=True)
        for file in files:
            dest_file = os.path.join(new_path, file)
            shutil.copy(os.path.join(path, file), dest_file)
            # Replace the import statement in the copied file
            replace_import_statement(dest_file)
    brownie_interfaces = f"{brownie_root}/interfaces"
    for path, _, files in os.walk(brownie_interfaces):
        new_path = path.replace(brownie_interfaces, f"{root_dir}/interfaces")
        os.makedirs(new_path, exist_ok=True)
        for file in files:
            dest_file = os.path.join(new_path, file)
            shutil.copy(os.path.join(path, file), dest_file)
            # Replace the import statement in the copied file
            replace_import_statement(dest_file)


if __name__ == "__main__":
    copy()

