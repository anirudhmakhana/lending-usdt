//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script{

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig{
        address usdt;    //USDT address
    }

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

    function getAnvilConfig() public pure returns (NetworkConfig memory){
        //usdt anvil
    }

}