const FarmSwap = artifacts.require("FarmSwap");
const USDCoin = artifacts.require("USDCoin");

const { assert } = require('chai');
const truffleAssert = require('truffle-assertions');

contract("FarmSwap", async accounts => {
    var owner = accounts[0];
    var instance;
    var usdc_instance;

    beforeEach(async () => {
        instance = await FarmSwap.new();
        usdc_instance = await USDCoin.new()

    });

    it("can create FarmSwap contract", async() => {
    });

    it("can make deposits of USDC", async() => {
    });

    it("can stake USDC", async() => {
        
    });

    it("cannot stake more USDC than approved", async() => {
        
    });

    it("cannot stake 0 USDC", async() => {
        
    });

    it("can get the number of stakes made", async() => {
        
    });

    it("can retrieve stake info", async() => {
       
    });
    
    it("raise error when withdraw non-existant stake", async() => {
        
    });

    it("can withdraw stake and FarmCoin rewards", async() => {
       
    });    



});