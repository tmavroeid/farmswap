const Staking = artifacts.require("Staking");

const { assert } = require('chai');
const truffleAssert = require('truffle-assertions');

contract("Staking", async accounts => {
    var owner = accounts[0];
    it("can make a stake", async() => {
        let instance = await Staking.deployed()
        let result = await instance._stake(accounts[1],1000, true,6)
        truffleAssert.eventEmitted(result, 'Staked');
    });

    it("it can withdraw stake", async() => {
        let instance = await Staking.deployed()
        await instance._stake(accounts[2], 1000, true, 6)
        // var response = await instance._stakeInfo(accounts[2],0);
        // assert.equal(response[0], accounts[2],"the account should be the same with the one made the deposit/stake");
        // assert.equal(response[1], 1000,"the amount should be 1000");
        // assert.equal(response[3], true,"the lockup decision should true");
        // assert.equal(response[4], 6,"the lockup period should be 6");
        // assert.equal(response[5], false,"the withdrawn value should be false ");
        let result = await instance._withdrawAmount(accounts[2],0);
        //let balance_after_withdraw = usdc_instance.balanceOf(accounts[6])
        console.log(result[0],result[1], result[2])
        //truffleAssert.eventEmitted(result, 'StakeWithdrawn');
    });
});