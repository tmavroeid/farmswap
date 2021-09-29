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

    function getFarmCoinOwner() external view returns (address) {
        return farmcoin.owner();
    }

    function deposit(uint256 _amount, bool _lockup, uint _lockup_period) external {
        require(_amount > 0, "FarmSwap: USDC tokens should be more than zero");
        // transfer the amount of USDC to the contract 
        _usdc.transferFrom(msg.sender, address(this), _amount);
        // keep track of this stake for the sender
        stake(msg.sender, _amount, _lockup, _lockup_period);
    }

    function getNumOfStakes() external view returns(uint){
        return stakesCount(msg.sender);
    }

    function getStakeInfo(uint _stake_index) external view returns(address,uint256, uint256, bool, uint, bool){
        return stakeInfo(msg.sender, _stake_index);
    }

    function withdraw(uint _stake_index) external returns(bool){
        //return staked amount of USDC 
        (uint256 amount, uint256 penalty, uint256 reward) = withdrawAmount(msg.sender, _stake_index);
        uint256 final_amount = amount - penalty;
        //approve allowance to enable withdraw
        if(_usdc.transfer(msg.sender, final_amount)){
            emit StakeWithdrawn(msg.sender, final_amount);
        }else{
            revert("Unable to transfer USDC");
        }
        //transfer FarmCoin rewards
        require(reward < farmcoin.totalSupply(), "FarmSwap: The amount of FarmCoins should me smaller than the totalSupply");
        if(farmcoin.transfer(msg.sender, reward)){
            emit RewardWithdrawn(msg.sender, reward);
        }else{
            revert("Unable to transfer FarmCoins");
        }
        return true;
    }

}
