pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {USDTLending} from "../src/Lending.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {MyERC20} from "../test/mock/MockUSDT.sol";

contract DeployLendingScript is Script {
    
    function run() external returns (USDTLending){
        //We do this before the broadcast because we  don't want to spend gas on the helperconfig  
        HelperConfig helperConfig = new HelperConfig();
        address usdtAddress = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        USDTLending lendingContract = new USDTLending(usdtAddress);

        // Check the chain ID
        uint256 chainId;
        assembly {
            chainId := chainid()
        }

        if (chainId != 1) {
            // Add money to the lending contract if chain ID is not 1
            MyERC20 usdt = MyERC20(usdtAddress);
            usdt.mint(address(lendingContract), 10e6);
        }

        vm.stopBroadcast();

        return lendingContract;
    }
}