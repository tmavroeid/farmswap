// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./FarmCoin.sol";
import "./Staking.sol";

contract FarmSwap is Ownable,Staking{

    FarmCoin private farmcoin;
    ERC20 private _usdc;
    mapping (address => uint) balances;
    
    event Deposited(address indexed account, ERC20 indexed token, uint256 amount);
    event StakeWithdrawn(address indexed account, uint256 amount);
    event RewardWithdrawn(address indexed account, uint256 amount);
    
    constructor(ERC20 token) {
        farmcoin = new FarmCoin(8000000000000);
        _usdc = token;
    }

}
