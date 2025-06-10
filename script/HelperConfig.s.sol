//SPDX-License-Identifier:MIT

// anvil ağında deploy edildiğinde kullanacağımız
// testnet ağında deploy edildiğinde kullanacağımız
// mainnet ağda kullanacağımız
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // ağa özel bilgileri structta oluşturup kullanabiliriz
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8; // sabit sayılar kontrattan geliyor
    int256 public constant INITAL_PRICE = 2000e8;
    struct NetworkConfig {
        address priceFeed; //ETH/USD price address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaETHConfig();
        } else {
            activeNetworkConfig = getAnvilETHConfig();
        }
    }

    // network config özel yapılı olduğu için memory kullanılmalı
    function getSepoliaETHConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getAnvilETHConfig() public pure returns (NetworkConfig memory) {
        // price feed address

        //1. deploy ederken mock kullan
        //2. mock address dön

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITAL_PRICE
        );
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
