// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";

contract CallAnything is Test {
    address public s_address;
    uint256 public s_amount;

    /// @notice Mock transfer function
    function transfer(address _someAddress, uint256 _amount) public {
        s_address = _someAddress;
        s_amount = _amount;
    }

    /// @notice Get the selector for the transfer function
    function getSelectorOfTransfer() public pure returns (bytes4 selector) {
        return bytes4(keccak256("transfer(address,uint256)"));
    }

    /// @notice Encode the transfer function call with parameters
    function addParamsToBytes4VersionOfTransfer(
        address _someAddress,
        uint256 _amount
    ) public pure returns (bytes memory) {
        return
            abi.encodeWithSelector(
                getSelectorOfTransfer(),
                _someAddress,
                _amount
            );
    }

    /// @notice Call the transfer function using a binary call
    function callTransferDirectlyWithBinary(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        (bool success, bytes memory returnedData) = address(this).call(
            abi.encodeWithSelector(getSelectorOfTransfer(), someAddress, amount)
        );
        return (bytes4(returnedData), success);
    }

    /// @notice Test case for calling transfer with binary encoding
    function testcallTransfer() public {
        address USER = makeAddr("USER");

        // Call the transfer function
        (bytes4 returnedValue, bool success) = callTransferDirectlyWithBinary(
            USER,
            50
        );

        // Assertions
        assertTrue(success, "The call to transfer failed");
        assertEq(returnedValue, bytes4(0), "Selector mismatch");
        assertEq(s_address, USER, "Address was not set correctly");
        assertEq(s_amount, 50, "Amount was not set correctly");
    }
}
