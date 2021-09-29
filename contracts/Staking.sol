// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Staking {


    /**
     * A stake struct is used to represent the way we store stakes, 
     * A Stake will contain the user, the amount staked, the timestamp, the lockup decision and the lockup_period
     */
    uint256 private constant _PENALTY = 10;
    struct Stake{
        uint256 amount;
        uint256 timestamp;
        bool lockup;
        //lockup_period is calculated in months
        uint lockup_period;
        bool withdrawn;
    }

    mapping(address => Stake[]) internal stakes;

    event Staked(address indexed user, uint256 amount, uint256 timestamp);

    function stake(address account, uint256 _amount, bool _lockup, uint _lockup_period) internal {
        // Simple check so that user does not stake 0 
        require(_amount > 0, "Cannot stake nothing");
        require(_lockup_period >= 0, "Cannot stake for a negative number of months.");
        uint256 timestamp = block.timestamp;
        Stake memory newStake;
        newStake.amount = _amount;
        newStake.timestamp = timestamp;
        newStake.lockup = _lockup;
        newStake.lockup_period = _lockup_period;
        newStake.withdrawn = false;

        stakes[account].push(newStake);
        emit Staked(account, _amount, timestamp);
    }

    /**
     * withdrawStake takes in an account and a index of the stake and returns the amount to be withdrawn
    */
    function withdrawAmount(address account, uint _index) internal view returns(uint256, uint256, uint256){
        require( stakes[account].length > 0, "The user does not have any stakes");
        // Grab user_index which is the index to use to grab the Stake[]
        Stake memory specificStake = stakes[account][_index];
        //Check if the stake is already withdrawn
        require(specificStake.withdrawn == false, "Stake is already withdrawn");
        //calculate penalty
        uint256 penalty = calculatePenalty(specificStake);
        //calculate reward
        uint256 reward = calculateStakeReward(specificStake);
        return (specificStake.amount, penalty, reward);

    }

    function stakesCount(address account) internal view returns (uint){
        return stakes[account].length;
    }

    function stakeInfo(address account, uint _index) internal view returns(uint256, uint256, bool, uint, bool){

        Stake memory specificStake = stakes[account][_index];

        return (
            specificStake.amount,
            specificStake.timestamp,
            specificStake.lockup,
            specificStake.lockup_period,
            specificStake.withdrawn
        );
    }
    function calculatePenalty(Stake memory specificStake) private view returns(uint256){
        uint256 penalty = 0;
        require(specificStake.withdrawn == false, "Stake is already withdrawn");
        //lockup period already passed in hours 
        uint stake_duration = (block.timestamp - specificStake.timestamp)/ 1 hours ;
        //transform declared lockup period from months to hours
        uint declared_lockup_period = specificStake.lockup_period * 730;
        //calculate penalty
        if (specificStake.lockup && stake_duration < declared_lockup_period)
            penalty = (specificStake.amount *_PENALTY)/100;
        return penalty;
    }

    function calculateStakeReward(Stake memory specificStake) private view returns(uint256){
        // First calculate how long the stake has been active
        // Use current seconds - the seconds since the stake was made
        // The output will be the stake duration in SECONDS ,
        // We will reward the user 10% per year when no-lockup. So thats 10% divided by 8760 hours => 0.0011% per hour.
        // the alghoritm is  seconds = block.timestamp - stake seconds (block.timestap - _stake.since)
        // we then multiply the amount of tokens with the hours staked , then divide by the rewardPerHour rate
        require(specificStake.withdrawn == false, "Stake is already withdrawn");
        uint256 rewardPerHour;
        uint256 reward = 0;
        //stake duration in seconds
        uint256 stake_duration = (block.timestamp - specificStake.timestamp);
        if (specificStake.lockup)
            //check that for a lockup_period of 6 months,the stake duration is at least equal to 6 months in seconds 
            if (specificStake.lockup_period==6 && stake_duration>=15768000){
                rewardPerHour = 460000;
            }else if (specificStake.lockup_period==12 && stake_duration>31536000){
                rewardPerHour = 340000;
            }
        else
            if(stake_duration>31536000)
                rewardPerHour = 110000;
        if (rewardPerHour>0)
            reward = ((stake_duration / 1 hours) * specificStake.amount) / rewardPerHour;            
        return reward;
    }

}