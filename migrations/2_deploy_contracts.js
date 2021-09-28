const USDCoin = artifacts.require("USDCoin");
const FarmSwap = artifacts.require("FarmSwap");
const Staking = artifacts.require("Staking");

module.exports = async function(deployer) {
  await deployer.deploy(USDCoin);
  const token = await USDCoin.deployed();
  await deployer.deploy(FarmSwap,token.address);
  await deployer.deploy(Staking);
};
