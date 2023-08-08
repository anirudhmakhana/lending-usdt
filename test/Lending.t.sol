// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/Lending.sol";
import {MyERC20} from "./mock/MockUSDT.sol";
import {DeployLendingScript} from "../script/DeployLending.s.sol";

contract LendingTest is Test{
    USDTLending public lending;
    address alice = vm.addr(0x1); //allows you to create a fake user. (Only in foundry!)
    // MyERC20 test_usdt;

    function setUp() public {
        DeployLendingScript script = new DeployLendingScript();
        lending = script.run();
        // test_usdt = new MyERC20("Test USDT", "TUSDT");
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


    function testBorrow() public {
        vm.prank(alice);
        lending.borrow(100);
        assertEq(lending.checkContractBalance(), 9999999999900);
    }

    function testRepay() public {
        //add funds to alice account
        MyERC20 usdt = MyERC20(lending.getUSDTAddress());
        usdt.mint(alice, 10);
        
        vm.startPrank(alice);
        console.log("Before Borrow",lending.checkContractBalance());
        lending.borrow(100);
        console.log("After Borrow", lending.checkContractBalance());
        console.log(lending.getDebts(alice));
        lending.repay();
        console.log(lending.getDebts(alice));
        console.log(lending.checkContractBalance());
        assertEq(lending.checkContractBalance(), 9_999_900);
        vm.stopPrank();

    }


}