// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IUSDT {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract USDTLending {

    IUSDT public USDT;
    mapping(address => uint256) public debts;
    // uint256 public constant PRECISION = 6;
    uint256 private interestPercentage  = 10;

    constructor(address _usdt) {
        USDT = IUSDT(_usdt);
    }

    function fund(uint256 amount, address _sender) external {
        require(USDT.transferFrom(_sender, address(this), amount), "Transfer failed.");
    }

    function borrow(uint256 amount) external {
        require(USDT.balanceOf(address(this)) >= amount, "Not enough USDT in the contract.");

        // Transfer USDT to the borrower
        require(USDT.transfer(msg.sender, amount), "Transfer failed.");

        // Record the debt (without interest)
        debts[msg.sender] += amount;
    }

    function repay() external {
        uint256 debt = debts[msg.sender];
        require(debt > 0, "You don't have any debt.");


        // Calculate repayment amount with 10% interest (1000 basis points)
        uint256 interest = calculate(debt, 1000);
        uint256 repaymentAmount = debt + interest;

        require(USDT.balanceOf(msg.sender) >= repaymentAmount, "Not enough USDT to repay.");

        // The USDT interface should be updated to have the transfer function
        require(USDT.transfer(address(this), repaymentAmount), "Transfer failed.");

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

    function getDebts(address borrower) external view returns (uint256) {
        return debts[borrower];
    }

    function getUSDTAddress() external view returns (address) {
        return address(USDT);
    }

    function calculate(uint256 amount, uint256 bps) public pure returns (uint256) {
        require((amount * bps) >= 10_000);
        return amount * bps / 10_000;
    }
}