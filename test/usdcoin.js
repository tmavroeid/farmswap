const USDCoin = artifacts.require("USDCoin");
const { assert } = require('chai');
const truffleAssert = require('truffle-assertions');

contract("USDCoin", async accounts => {
    var owner = accounts[0];
    var instance;

    beforeEach(async () => {
        instance = await USDCoin.new()

    });

    it("can add USDC name and symbol properly", async() => {
        
    });

    it("minting", async() => {
        
    });

    it("minting to 0 address", async()=>{
        
    });

    it("minting 0 amount of USDC", async()=>{
        
    });

    it("burning", async() => {
        
    });

    it("burning to 0 address", async()=>{
        
    });

    it("burning more amount of USDC than the amount of balance", async()=>{
        
    });

    it("can transfer USDC from one account to another", async()=>{
        
    });

    it("cannot transfer more USDC from one account than existing", async()=>{
        
    });
});