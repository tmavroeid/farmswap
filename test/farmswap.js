const FarmSwap = artifacts.require("FarmSwap");
const USDCoin = artifacts.require("USDCoin");

const { assert } = require('chai');
const truffleAssert = require('truffle-assertions');

contract("FarmSwap", async accounts => {
    var owner = accounts[0];
    var instance;
    var usdc_instance;

    beforeEach(async () => {
        usdc_instance = await USDCoin.new();
        instance = await FarmSwap.new(usdc_instance.address);
    });

    it("can create FarmSwap contract", async() => {
        assert.equal(instance.address, await instance.getFarmCoinOwner(),"The owner of FarmCoin contract should be the FarmSwap Contract");
    });

    it("can make deposits of USDC", async() => {
        await usdc_instance.mint(accounts[1],2000)
        //approval is required in order to make the deposit
        await usdc_instance.approve(instance.address,1000, {from: accounts[1]})
        await instance.deposit(1000,true,6,{from:accounts[1]})
        let balance_after = await usdc_instance.balanceOf(accounts[1])
        assert.equal(balance_after.toNumber(), 1000,"the balance should be 1000 less due to deposit");
    });

    it("can stake USDC", async() => {
        await usdc_instance.mint(accounts[1],2000)
        //approval is required in order to make the deposit
        await usdc_instance.approve(instance.address,1000, {from: accounts[1]})
        let result = await instance.deposit(1000,true,6,{from:accounts[1]})
        truffleAssert.eventEmitted(result, 'Staked');
    });

    it("cannot stake more USDC than approved", async() => {
        await usdc_instance.mint(accounts[1],2000)
        //approval is required in order to make the deposit
        await usdc_instance.approve(instance.address,1000, {from: accounts[1]})
        try{
            await instance.deposit(2000,true,6,{from:accounts[1]})
        }catch(error){
            assert.equal(error.reason, "USDC: the allowance should be more or equal to the tokens to be transfered");
        }
    });

    it("cannot stake 0 USDC", async() => {
        await usdc_instance.mint(accounts[1],2000)
        //approval is required in order to make the deposit
        await usdc_instance.approve(instance.address,0, {from: accounts[1]})
        try{
            await instance.deposit(0,true,6,{from:accounts[1]});
        }catch(error){
            assert.equal(error.reason, "FarmSwap: USDC tokens should be more than zero");
        }
    });

    it("can get the number of stakes made", async() => {
        await usdc_instance.mint(accounts[1],2000)
        //approval is required in order to make the deposit
        await usdc_instance.approve(instance.address,1000, {from: accounts[1]})
        await instance.deposit(1000,true,6,{from:accounts[1]})
        let num = await instance.getNumOfStakes({from:accounts[1]});
        assert.equal(num.toNumber(), 1,"1 stake should be made");
    });

    it("can retrieve stake info", async() => {
        await usdc_instance.mint(accounts[1],2000)
        //approval is required in order to make the deposit
        await usdc_instance.approve(instance.address,1000, {from: accounts[1]})
        await instance.deposit(1000,true,6,{from:accounts[1]})
        var response = await instance.getStakeInfo(0,{from:accounts[1]});
        assert.equal(response[0], accounts[1],"the account should be the same with the one made the deposit/stake");
        assert.equal(response[1], 1000,"the amount should be 1000");
        assert.equal(response[3], true,"the lockup decision should true");
        assert.equal(response[4], 6,"the lockup period should be 6");
        assert.equal(response[5], false,"the withdrawn value should be false ");
    });
    
    it("raise error when withdraw non-existant stake", async() => {
        try {
            await instance.withdraw(1,{from:accounts[1]});
        }catch(error){
            assert.equal(error.reason, "FarmSwap: The user does not have any stakes")
        }        
    });

    it("can withdraw stake and FarmCoin rewards", async() => {
        await usdc_instance.mint(accounts[1],2000)
        //approval is required in order to make the deposit
        await usdc_instance.approve(instance.address,1000, {from: accounts[1]})
        await instance.deposit(1000,true,6,{from:accounts[1]});        
        let result = await instance.withdraw(0,{from:accounts[1]});
        truffleAssert.eventEmitted(result, "StakeWithdrawn");
        truffleAssert.eventEmitted(result,"RewardWithdrawn");
        // let balance_farmcoin = await instance.getFarmCoinBalance(accounts[6]);
        // assert.equal(balance_farmcoin.toNumber(), 0,"the withdrawn value should be false ");
    }); 



});