// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IUSDT {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract USDTLending {
    address public owner;
    IUSDT public USDT;
    
    mapping(address => uint256) public debts;
    
    // Contract constructor
    constructor() {
        owner = msg.sender;
        USDT = IUSDT(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    }

    function borrow(uint256 amount) external {
        require(USDT.balanceOf(address(this)) >= amount, "Not enough USDT in the contract.");

        // Transfer USDT to the borrower
        USDT.transfer(msg.sender, amount);
        
        // Record the debt
        debts[msg.sender] += amount + (amount / 10); // 10% interest
    }

    function repay() external {
        uint256 debt = debts[msg.sender];
        require(debt > 0, "You don't have any debt.");
        require(USDT.balanceOf(msg.sender) >= debt, "Not enough USDT to repay.");

        // Transfer USDT from borrower to this contract
        USDT.transferFrom(msg.sender, address(this), debt);
        
        // Clear the debt
        debts[msg.sender] = 0;
    }

    function checkDebt(address borrower) external view returns (uint256) {
        return debts[borrower];
    }

    // Function to check contract's balance
    function checkContractBalance() public view returns (uint256) {
        return USDT.balanceOf(address(this));
    }
}