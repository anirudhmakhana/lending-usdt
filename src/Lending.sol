// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IUSDT {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract USDTLending {
    address public owner; //this is the owner of the contract, which I will use to fund the contract (only for testing purposes)
    IUSDT public USDT;
    mapping(address => uint256) public debts;

    constructor(address _usdt) {
        owner = msg.sender;
        USDT = IUSDT(_usdt);
    }

    // // Modifier to require that the caller is the owner
    // modifier onlyOwner() {
    //     require(msg.sender == owner, "Only the owner can call this function.");
    //     _;
    // }

    // Function to allow the owner to fund the contract
    function fund(uint256 amount) external {
        require(USDT.transferFrom(msg.sender, address(this), amount), "Transfer failed.");
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

        // Calculate repayment amount with 10% interest
        uint256 repaymentAmount = debt + (debt / 10);

        require(USDT.balanceOf(msg.sender) >= repaymentAmount, "Not enough USDT to repay.");

        // Transfer USDT from borrower to this contract
        require(USDT.transferFrom(msg.sender, address(this), repaymentAmount), "Transfer failed.");

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

    /**
     * Getters functions 
     */
    function getOwner() external view returns (address) {
        return owner;
    }

    function getDebts(address borrower) external view returns (uint256) {
        return debts[borrower];
    }
}