const FarmCoin = artifacts.require("FarmCoin");
const { assert } = require('chai');
const truffleAssert = require('truffle-assertions');

contract("FarmCoin", async accounts => {
    var owner = accounts[0];
    var instance;

    beforeEach(async () => {
        instance = await FarmCoin.new(8000, {from:owner});

    });

    it("can add USDC name and symbol properly", async() => {
        assert.equal("Farm Coin", await instance.name.call());
        assert.equal("FMC", await instance.symbol.call());
    });

    it("can get the decimals", async() => {
        let dec = await instance.decimals.call()
        assert.equal(dec,10, "Decimals should be 10");
    });

    it("can get the totalSupply", async() => {
        let totalSupply = await instance.totalSupply.call();
        assert.equal(totalSupply,8000, "Total supply should be 8000");
    });

    it("can get the balance of owner", async() => {
        let balance = await instance.balanceOf(owner, {from:owner})
        assert.equal(balance,8000, "Balance of owner should be 8000");
    });

    it("can transfer FMC from one account to another", async()=>{
        await instance.transfer(accounts[1],100, {from:owner});
        let balance = await instance.balanceOf(accounts[1], {from: owner});
        assert.equal(balance.toNumber(), 100, "The amount of FMC should be 100");
    });

    it("cannot transfer more FMC from one account than existing", async()=>{
        try {
            await instance.transfer(accounts[1],300, {from:owner});
        }catch(error){
            assert.equal(error.reason, "FMC: tokens should be less/equal to the balance of the sender");
        }
    });

});