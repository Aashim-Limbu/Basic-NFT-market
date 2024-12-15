// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import {Test, console} from "forge-std/Test.sol";
import {ReactionNft} from "../src/ReactionNFT.sol";
import {DeployReactionNFT} from "../script/DeployReactionNFT.s.sol";

contract ReactionNftTest is Test {
    ReactionNft reactionNft;
    DeployReactionNFT deployer;
    string public constant LIKE =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48IS0tIFVwbG9hZGVkIHRvOiBTVkcgUmVwbywgd3d3LnN2Z3JlcG8uY29tLCBHZW5lcmF0b3I6IFNWRyBSZXBvIE1peGVyIFRvb2xz IC0tPgo8c3ZnIHdpZHRoPSI4MDBweCIgaGVpZ2h0PSI4MDBweCIgdmlld0JveD0iMCAwIDQ4IDQ4 IiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8cGF0aCBk PSJNNC4xODg5OCAyMi4xNzMzQzQuMDg3MzcgMjEuMDA0NyA1LjAwODUyIDIwIDYuMTgxNDYgMjBI MTBDMTEuMTA0NiAyMCAxMiAyMC44OTU0IDEyIDIyVjQxQzEyIDQyLjEwNDYgMTEuMTA0NiA0MyAx MCA0M0g3LjgzMzYzQzYuNzk2MjIgNDMgNS45MzEwMiA0Mi4yMDY4IDUuODQxMTUgNDEuMTczM0w0 LjE4ODk4IDIyLjE3MzNaIiBmaWxsPSIjMkY4OEZGIiBzdHJva2U9IiMwMDAwMDAiIHN0cm9rZS13 aWR0aD0iNCIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIi8+ CjxwYXRoIGQ9Ik0xOCAyMS4zNzQ1QzE4IDIwLjUzODggMTguNTE5NCAxOS43OTA4IDE5LjI3NTMg MTkuNDM0NUMyMC45MjM4IDE4LjY1NzQgMjMuNzMyOSAxNy4wOTM4IDI1IDE0Ljk4MDVDMjYuNjMz MSAxMi4yNTY5IDI2Ljk0MTEgNy4zMzU5NSAyNi45OTEyIDYuMjA4NzhDMjYuOTk4MiA2LjA1MDk5 IDI2Ljk5MzcgNS44OTMwMSAyNy4wMTU0IDUuNzM2NTZDMjcuMjg2MSAzLjc4NDQ2IDMxLjA1NDMg Ni4wNjQ5MiAzMi41IDguNDc2MTJDMzMuMjg0NiA5Ljc4NDcxIDMzLjM4NTIgMTEuNTA0IDMzLjMw MjcgMTIuODQ2M0MzMy4yMTQ0IDE0LjI4MjUgMzIuNzkzMyAxNS42Njk5IDMyLjM4MDIgMTcuMDQ4 M0wzMS41IDE5Ljk4NDVINDIuMzU2OUM0My42ODMyIDE5Ljk4NDUgNDQuNjQyMSAyMS4yNTE4IDQ0 LjI4MTYgMjIuNTI4MUwzOC45MTEzIDQxLjU0MzZDMzguNjY4IDQyLjQwNTEgMzcuODgxOCA0MyAz Ni45ODY2IDQzSDIwQzE4Ljg5NTQgNDMgMTggNDIuMTA0NiAxOCA0MVYyMS4zNzQ1WiIgZmlsbD0i IzJGODhGRiIgc3Ryb2tlPSIjMDAwMDAwIiBzdHJva2Utd2lkdGg9IjQiIHN0cm9rZS1saW5lY2Fw PSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8L3N2Zz4=";
    string public constant DISLIKE =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48IS0tIFVwbG9hZGVkIHRvOiBT VkcgUmVwbywgd3d3LnN2Z3JlcG8uY29tLCBHZW5lcmF0b3I6IFNWRyBSZXBvIE1peGVyIFRvb2xz IC0tPgo8c3ZnIHdpZHRoPSI4MDBweCIgaGVpZ2h0PSI4MDBweCIgdmlld0JveD0iMCAwIDQ4IDQ4 IiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8cGF0aCBk PSJNNC4xODA1MSAyNi44MzM5QzQuMDgzMzQgMjcuOTk5OSA1LjAwMzUyIDI5IDYuMTczNiAyOUgx MEMxMS4xMDQ2IDI5IDEyIDI4LjEwNDYgMTIgMjdWN0MxMiA1Ljg5NTQzIDExLjEwNDYgNSAxMCA1 SDcuODQwMjdDNi44MDAwOSA1IDUuOTMzNTYgNS43OTczMyA1Ljg0NzE3IDYuODMzOTFMNC4xODA1 MSAyNi44MzM5WiIgZmlsbD0iIzJGODhGRiIgc3Ryb2tlPSIjMDAwMDAwIiBzdHJva2Utd2lkdGg9 IjQiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8cGF0 aCBkPSJNMTggMjYuNjI1NUMxOCAyNy40NjEyIDE4LjUxOTQgMjguMjA5MiAxOS4yNzUzIDI4LjU2 NTVDMjAuOTIzOCAyOS4zNDI2IDIzLjczMjkgMzAuOTA2MiAyNSAzMy4wMTk1QzI2LjYzMzEgMzUu NzQzMSAyNi45NDExIDQwLjY2NCAyNi45OTEyIDQxLjc5MTJDMjYuOTk4MiA0MS45NDkgMjYuOTkz NyA0Mi4xMDcgMjcuMDE1NCA0Mi4yNjM0QzI3LjI4NjEgNDQuMjE1NSAzMS4wNTQzIDQxLjkzNTEg MzIuNSAzOS41MjM5QzMzLjI4NDYgMzguMjE1MyAzMy4zODUyIDM2LjQ5NiAzMy4zMDI3IDM1LjE1 MzdDMzMuMjE0NCAzMy43MTc1IDMyLjc5MzMgMzIuMzMwMSAzMi4zODAyIDMwLjk1MTdMMzEuNSAy OC4wMTU1SDQyLjM1NjlDNDMuNjgzMiAyOC4wMTU1IDQ0LjY0MjEgMjYuNzQ4MiA0NC4yODE2IDI1 LjQ3MTlMMzguOTExMyA2LjQ1NjQyQzM4LjY2OCA1LjU5NDkgMzcuODgxOCA1IDM2Ljk4NjYgNUgy MEMxOC44OTU0IDUgMTggNS44OTU0MyAxOCA3VjI2LjYyNTVaIiBmaWxsPSIjMkY4OEZGIiBzdHJv a2U9IiMwMDAwMDAiIHN0cm9rZS13aWR0aD0iNCIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJv a2UtbGluZWpvaW49InJvdW5kIi8+Cjwvc3ZnPg==";
    address user = makeAddr("USER");

    function setUp() public {
        deployer = new DeployReactionNFT();
    }

    function testViewTokenURI() public {
        vm.prank(user); //solve the ERC721 Reciever error reactionNft.mintNft();
        console.log(reactionNft.tokenURI(0));
    }

    // function testConvertImageFunction() public view {
    //     string
    //         memory test = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPCEtLSBVcGxvYWRlZCB0bzogU1ZHIFJlcG8sIHd3dy5zdmdyZXBvLmNvbSwgR2VuZXJhdG9yOiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4gPHN2ZyB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiCiAgICB2aWV3Qm94PSIwIDAgNDggNDgiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8cGF0aAogICAgICAgIGQ9Ik00LjE4ODk4IDIyLjE3MzNDNC4wODczNyAyMS4wMDQ3IDUuMDA4NTIgMjAgNi4xODE0NiAyMEgxMEMxMS4xMDQ2IDIwIDEyIDIwLjg5NTQgMTIgMjJWNDFDMTIgNDIuMTA0NiAxMS4xMDQ2IDQzIDEwIDQzSDcuODMzNjNDNi43OTYyMiA0MyA1LjkzMTAyIDQyLjIwNjggNS44NDExNSA0MS4xNzMzTDQuMTg4OTggMjIuMTczM1oiCiAgICAgICAgZmlsbD0iIzJGODhGRiIgc3Ryb2tlPSIjMDAwMDAwIiBzdHJva2Utd2lkdGg9IjQiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgLz4KICAgIDxwYXRoCiAgICAgICAgZD0iTTE4IDIxLjM3NDVDMTggMjAuNTM4OCAxOC41MTk0IDE5Ljc5MDggMTkuMjc1MyAxOS40MzQ1QzIwLjkyMzggMTguNjU3NCAyMy43MzI5IDE3LjA5MzggMjUgMTQuOTgwNUMyNi42MzMxIDEyLjI1NjkgMjYuOTQxMSA3LjMzNTk1IDI2Ljk5MTIgNi4yMDg3OEMyNi45OTgyIDYuMDUwOTkgMjYuOTkzNyA1Ljg5MzAxIDI3LjAxNTQgNS43MzY1NkMyNy4yODYxIDMuNzg0NDYgMzEuMDU0MyA2LjA2NDkyIDMyLjUgOC40NzYxMkMzMy4yODQ2IDkuNzg0NzEgMzMuMzg1MiAxMS41MDQgMzMuMzAyNyAxMi44NDYzQzMzLjIxNDQgMTQuMjgyNSAzMi43OTMzIDE1LjY2OTkgMzIuMzgwMiAxNy4wNDgzTDMxLjUgMTkuOTg0NUg0Mi4zNTY5QzQzLjY4MzIgMTkuOTg0NSA0NC42NDIxIDIxLjI1MTggNDQuMjgxNiAyMi41MjgxTDM4LjkxMTMgNDEuNTQzNkMzOC42NjggNDIuNDA1MSAzNy44ODE4IDQzIDM2Ljk4NjYgNDNIMjBDMTguODk1NCA0MyAxOCA0Mi4xMDQ2IDE4IDQxVjIxLjM3NDVaIgogICAgICAgIGZpbGw9IiMyRjg4RkYiIHN0cm9rZT0iIzAwMDAwMCIgc3Ryb2tlLXdpZHRoPSI0IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiIC8+Cjwvc3ZnPgo=";
    //     string
    //         memory challanger = '<?xml version="1.0" encoding="utf-8"?><!-- Uploaded to: SVG Repo, www.svgrepo.com, Generator: SVG Repo Mixer Tools --><svg width="800px" height="800px" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.18898 22.1733C4.08737 21.0047 5.00852 20 6.18146 20H10C11.1046 20 12 20.8954 12 22V41C12 42.1046 11.1046 43 10 43H7.83363C6.79622 43 5.93102 42.2068 5.84115 41.1733L4.18898 22.1733Z" fill="#2F88FF" stroke="#000000" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/><path d="M18 21.3745C18 20.5388 18.5194 19.7908 19.2753 19.4345C20.9238 18.6574 23.7329 17.0938 25 14.9805C26.6331 12.2569 26.9411 7.33595 26.9912 6.20878C26.9982 6.05099 26.9937 5.89301 27.0154 5.73656C27.2861 3.78446 31.0543 6.06492 32.5 8.47612C33.2846 9.78471 33.3852 11.504 33.3027 12.8463C33.2144 14.2825 32.7933 15.6699 32.3802 17.0483L31.5 19.9845H42.3569C43.6832 19.9845 44.6421 21.2518 44.2816 22.5281L38.9113 41.5436C38.668 42.4051 37.8818 43 36.9866 43H20C18.8954 43 18 42.1046 18 41V21.3745Z" fill="#2F88FF" stroke="#000000" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/></svg>';
    //     string memory actualUri = deployer.convertToImageURI(challanger);
    //     console.log(actualUri);
    //     assert(
    //         keccak256(abi.encodePacked(test)) ==
    //             keccak256(abi.encodePacked(actualUri))
    //     );
    // }
}
