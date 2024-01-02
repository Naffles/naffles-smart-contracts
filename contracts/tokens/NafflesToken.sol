// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin/token/ERC20/ERC20.sol";
import "openzeppelin/token/ERC20/extensions/ERC20Capped.sol";
import "openzeppelin/access/Ownable.sol";
import "forge-std/Test.sol";

contract NafflesToken is ERC20Capped, Ownable {
    event Mint(address indexed to, uint256 amount);
    mapping(address=>bool) public minters;

    constructor(uint256 cap_, uint256 initialSupply) ERC20("Naffles", "NAFL") ERC20Capped(cap_){
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) external{
        require(minters[msg.sender], "not a minter");
        
        _mint(to, amount);
        emit Mint(to, amount);
    }

    function setMinter(address _minter) public onlyOwner{
        require(_minter != address(0x0), "invalid address");
        minters[_minter] = true;
    }
}