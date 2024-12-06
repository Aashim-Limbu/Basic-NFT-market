// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "src/BasicNFT.sol";

contract MintNFT is Script {
    string constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address latestDeployment = DevOpsTools.get_most_recent_deployment(
            "BasicNFT",
            block.chainid
        );
        mintNftOnContract(latestDeployment);
    }

    function mintNftOnContract(address latestdeployment) public {
        vm.startBroadcast();
        BasicNFT(latestdeployment).mintNft("");
        vm.stopBroadcast();
    }
}
