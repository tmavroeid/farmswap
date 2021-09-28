// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDCoin is ERC20 {
    uint256 _totalSupply;
    address payable owner;
    uint private INITIAL_SUPPLY = 100000000000000000000 * (10 ** decimals());

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perfom this action");
        _;
    }
    
    constructor() ERC20("USD Coin", "USDC") {
        owner = payable(msg.sender);
        _totalSupply = INITIAL_SUPPLY;
	    balances[msg.sender] = INITIAL_SUPPLY;
    }

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }
    
    
}
