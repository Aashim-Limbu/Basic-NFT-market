// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import {Script} from "forge-std/Script.sol";
import {ReactionNft} from "src/ReactionNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployReactionNFT is Script {
    // function run() external returns (ReactionNft) {
    //     vm.startBroadcast();
    //     ReactionNft reactionNft = new ReactionNft();
    //     vm.stopBroadcast();
    //     return reactionNft;
    // }

    function convertToImageURI(
        string memory svgImage
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(svgImage));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}