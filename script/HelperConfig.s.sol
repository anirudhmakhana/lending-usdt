//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MyERC20} from "../test/mock/MockUSDT.sol";

contract HelperConfig is Script{

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig{
        address usdt;    //USDT address
    }

    event HelperConfig__CreatedMockUSDT(address mockusdt);

    constructor(){
        if(block.chainid == 1){
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory mainnetConfig = NetworkConfig(
            0xdAC17F958D2ee523a2206206994597C13D831ec7
        );
        return mainnetConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory){
        // if(activeNetworkConfig.usdt != address(0)){
        //     return activeNetworkConfig;
        // }
        vm.startBroadcast();
        MyERC20 usdt = new MyERC20("Test USDT", "TUSDT");
        vm.stopBroadcast();
        emit HelperConfig__CreatedMockUSDT(address(usdt));

        NetworkConfig memory anvilNetworkConfig = NetworkConfig({
            usdt: address(usdt)
        });
        return anvilNetworkConfig;

    }

}