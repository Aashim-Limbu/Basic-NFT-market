// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    uint256 private s_tokenCounter;

    constructor() ERC721("Nepali", "NEP") {
        s_tokenCounter  = 0;
    }
    function mintNft() public {}
    function tokenURI(uint256 tokenId) public view override returns(string memory) {
        
    }
}
