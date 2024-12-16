// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "src/BasicNFT.sol";

contract MintReactionNFT is Script {
    string constant PUG =
        "ipfs://bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/4018";

    function run() external {
        address latestDeployment = DevOpsTools.get_most_recent_deployment(
            "BasicNFT",
            block.chainid
        );
        mintNftOnContract(latestDeployment);
    }

    function mintNftOnContract(address latestdeployment) public {
        vm.startBroadcast();
        BasicNFT(latestdeployment).mintNft(PUG);
        vm.stopBroadcast();
    }
}
