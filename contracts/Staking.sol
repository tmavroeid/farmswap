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

    
    /**
    * stake is used to make a stake for an sender. It will remove the amount staked from the stakers account and place those tokens 
    */
    function stake(address account, uint256 _amount, bool _lockup, uint _lockup_period) internal {
        // Simple check so that user does not stake 0 
        require(_amount > 0, "Cannot stake nothing");
        require(_lockup_period >= 0, "Cannot stake for a negative number of months.");
        uint256 timestamp = block.timestamp;
        address staker = account;
        Stake memory newStake;
        newStake.user = staker;
        newStake.amount = _amount;
        newStake.timestamp = timestamp;
        newStake.lockup = _lockup;
        newStake.lockup_period = _lockup_period;
        newStake.withdrawn = false;

        stakes[staker].push(newStake);
        emit Staked(account, _amount, timestamp);
    }

    /**
     * withdrawStake takes in an account and a index of the stake and returns the amount to be withdrawn
    */
    function withdrawAmount(address account, uint _index) internal view returns(uint256){
        // Grab user_index which is the index to use to grab the Stake[]
        Stake memory specificStake = stakes[account][_index];
        //Check if the stake is already withdrawn
        require(specificStake.withdrawn == false, "Stake is already withdrawn");
        uint256 amount = specificStake.amount;
        return amount;

    }

    function stakesCount(address account) internal view returns (uint){
        return stakes[account].length;
    }

    function stakeInfo(address account, uint _index) internal view returns(address, uint256, uint256, bool, uint, bool){

        Stake memory specificStake = stakes[account][_index];

        return (
            specificStake.user,
            specificStake.amount,
            specificStake.timestamp,
            specificStake.lockup,
            specificStake.lockup_period,
            specificStake.withdrawn
        );
    }
    

}