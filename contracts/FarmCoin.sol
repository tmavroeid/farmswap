// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FarmCoin is Ownable,ERC20 {
    mapping (address => uint256) balances;
    uint256 _totalSupply;
    
    constructor(uint _amount) ERC20("Farm Coin", "FMC"){
        _totalSupply = _amount;
        balances[msg.sender] = _amount;
    }

    function decimals() public pure override returns (uint8) {
        return 10;
    }

    function balanceOf(address account) public view override returns (uint256){
         return balances[account];
    }

    function totalSupply() public view override returns (uint256){
        return _totalSupply;
    }

    function transfer(address to, uint256 tokens) public override returns (bool) {
        require(tokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - tokens;
        balances[to] = balances[to]  + tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

}