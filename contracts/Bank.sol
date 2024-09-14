// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Bank {
    address public immutable owner;
    // event 
    event Deposit(address _addr,uint256 amout);
    event Withdraw(uint256 amount);

    //receive
    receive() external payable{
        require(owner == msg.sender,"Not owner!");
        emit Deposit(msg.sender,msg.value);
    }

    //withdraw money function
    function withdraw() external{
        require(msg.sender == owner,"Not owner!");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    constructor() payable{
        owner = msg.sender;
    }
}