from setuptools import setup

requires = [
    'eth-typing~=3.3.0',
    'eth-account~=0.8.0',
    "web3~=6.0",
    "zksync2~=0.4.0"
]

setup(
    name="naffle-smart-contracts-deployment",
    version="0.0.1",
    author="Naffles",
    install_requires=requires,
)
