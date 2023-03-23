import os

from setuptools import setup

requires = [
    "eth-brownie~=1.19.3",
    "eth-abi~=2.2.0",
    "pycryptodome",
    "web3~=5.31.0"
]

setup(
    name="naffles-smart-contracts",
    version="0.0.1",
    author="Naffles",
    install_requires=requires,
)
