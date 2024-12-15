// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract ReactionNft is ERC721 {
    error ReactionNFT__PermissionDenied(address owner, address sender);
    uint256 private s_tokenCounter;
    string private s_likeSVGImageURI;
    string private s_disLikeSVGImageURI;

    enum Reaction {
        LIKE,
        UNLIKE
    }
    mapping(uint256 tokenId => Reaction) private s_tokenIdToReaction;

    constructor(
        string memory _likeSvgImgUri,
        string memory _disLikeSvgImgUri
    ) ERC721("Reaction NFT", "RES") {
        s_tokenCounter = 0;
        s_likeSVGImageURI = _likeSvgImgUri;
        s_disLikeSVGImageURI = _disLikeSvgImgUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToReaction[s_tokenCounter] = Reaction.LIKE;
        s_tokenCounter++;
    }

    function toggleReaction(uint256 tokenId) public {
        if (!_isAuthorized(ownerOf(tokenId), msg.sender, tokenId)) {
            revert ReactionNFT__PermissionDenied(ownerOf(tokenId), msg.sender);
        }
        s_tokenIdToReaction[tokenId] = (s_tokenIdToReaction[tokenId] ==
            Reaction.LIKE)
            ? Reaction.UNLIKE
            : Reaction.LIKE;
    }

    //we need to append the baseURI for image to render on website
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory tokenUri) {
        string memory imageURI;
        if (s_tokenIdToReaction[tokenId] == Reaction.LIKE) {
            imageURI = s_likeSVGImageURI;
        } else {
            imageURI = s_disLikeSVGImageURI;
        }

        return (
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", ',
                                '"description": "A Reaction NFT!", ',
                                '"attributes": [{"trait_type": "Reaction", "value": 100}], ',
                                '"image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            )
        );
    }

    /*//////////////////////////////////////////////////////////////
                                GETTERS
    //////////////////////////////////////////////////////////////*/
    function getCurrentReaction(
        uint256 tokenId
    ) external view returns (Reaction) {
        return s_tokenIdToReaction[tokenId];
    }
}
