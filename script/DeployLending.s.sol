// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {USDTLending} from "../src/Lending.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployLendingScript is Script {
    
    
    function run() external returns (USDTLending){
        //We do this before the broadcast because we  don't want to spend gas on the helperconfig  
        HelperConfig helperConfig = new HelperConfig();
        address usdtAddress = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        USDTLending lendingContract = new USDTLending(usdtAddress);
        vm.stopBroadcast();

        return lendingContract;
    }
}
