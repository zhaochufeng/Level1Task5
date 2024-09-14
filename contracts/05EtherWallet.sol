// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract EtherWallet {
    address public immutable owner;
    event Log(string name,address from,uint256 value,bytes data);

    constructor() {
        owner = payable(msg.sender);
    }
    
    receive() external payable{
        // require(msg.sender == owner,"not owner!");
        emit Log("receive",msg.sender,msg.value,"");
    }
    
    function withdraw1() external {
        require(msg.sender == owner,"not owner!");
        payable(msg.sender).transfer(100);
    }
    function withdraw2() external {
        require(msg.sender == owner,"not owner!");
        bool success  = payable(msg.sender).send(100);
        require(success,"send fail!");
    }

     function withdraw3() external {
        require(msg.sender == owner,"not owner!");
        (bool success,) = msg.sender.call{value: address(this).balance}("");
        require(success,"call fail!");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

}