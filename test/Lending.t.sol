// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/Lending.sol";
import {MyERC20} from "../src/MockUSDT.sol";
import {DeployLendingScript} from "../script/DeployLending.s.sol";

contract LendingTest is Test, MyERC20{
    USDTLending public lending;
    address USER = makeAddr("user"); //allows you to create a fake user. (Only in foundry!)

    function setUp() public {
        DeployLendingScript script = new DeployLendingScript();
        console.log("Deploying lending contract...");
        lending = script.run();
        console.log("Lending contract deployed at: ", address(lending));
    }

    function testInitialBalance() public {
        uint256 balance = lending.checkContractBalance();
        console.log("Initial balance: ", balance);
        assertEq(balance, 0);
    }

    function testNotEnoughUSDT() public {
        vm.expectRevert(); //Hey VM, we expect a revert here
        lending.borrow(100); //lending doesn't have enough USDT
    }

    function testFundContract() public {
        //vm.prank can be used to set the account for the next line
        vm.prank(USER); //pretend to be the user
        // vm.prank(address());
        console.log("User balance: ", lending.checkContractBalance());
        lending.fund(1000); //fund the contract with 1000 USDT

    }

}