// SPDX-License-Identifier: MTI
pragma solidity >=0.8.0 <0.9.0;
import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract DeployBasicNft is Script {
    function run() public returns (BasicNFT) {
        vm.startBroadcast();
        BasicNFT basicNFT = new BasicNFT();
        vm.stopBroadcast();
        return basicNFT;
    }
}
