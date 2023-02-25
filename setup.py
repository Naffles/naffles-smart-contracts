import os

from setuptools import setup

requires = [
    "eth-brownie~=1.19.2",
    "web3~=5.31.3",
]

setup(
    name="naffles-smart-contracts",
    version="0.0.1",
    author="Naffles",
    install_requires=requires,
)
