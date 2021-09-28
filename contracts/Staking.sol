// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract Staking {
    /**
     * A stake struct is used to represent the way we store stakes, 
     * A Stake will contain the user, the amount staked, the timestamp, the lockup decision and the lockup_period
     */
    uint256 private constant _PENALTY = 10;
    struct Stake{
        address user;
        uint256 amount;
        uint256 timestamp;
        bool lockup;
        //lockup_period is calculated in months
        uint lockup_period;
        bool withdrawn;
    }

    mapping(address => Stake[]) internal stakes;

    event Staked(address indexed user, uint256 amount, uint256 timestamp);


}