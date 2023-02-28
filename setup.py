import os

from setuptools import setup

requires = [
    "eth-brownie~=1.19.2",
    "eth-abi~=3.0.1",
    "web3~=5.31.3",
    "pycryptodome",
]

setup(
    name="naffles-smart-contracts",
    version="0.0.1",
    author="Naffles",
    install_requires=requires,
)
