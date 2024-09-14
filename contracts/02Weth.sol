// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

/**
     * 3 个查询
    balanceOf: 查询指定地址的 Token 数量
    allowance: 查询指定地址对另外一个地址的剩余授权额度
    totalSupply: 查询当前合约的 Token 总量
    2 个交易
    transfer: 从当前调用者地址发送指定数量的 Token 到指定地址。
    这是一个写入方法，所以还会抛出一个 Transfer 事件。
    transferFrom: 当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token 拿到它自己的合约中。
    2 个事件
    Transfer
    Approval
    1 个授权
    approve: 授权指定地址可以操作调用者的最大 Token 数量。

    */

contract Weth {
    mapping(address => uint256) balanceOf;
    mapping(address => mapping(address => uint256)) allowance;
    string public name = "Wrapper Ether";
    string public symbol = "Weth";
    uint8 public decimal = 18;

    event Approval(address indexed _addr, address indexed delegateAds,uint256 amount);
    event Transfer(address indexed _addr, address indexed toAds, uint256 amount);
    event Deposit(address toAds,uint256 amout);
    event Withdraw(address indexed _addr,uint256 amout);


    receive() external payable{
        deposit();
    }

    fallback() external payable{
        deposit();
    }

    function transferFrom(
        address _addr,
        address toAds,
        uint256 amount
    ) public returns (bool) {
        require(balanceOf[_addr] >= amount);
        if (_addr != msg.sender) {
            require(allowance[_addr][msg.sender] >= amount);
            allowance[_addr][msg.sender] -= amount;
        }
        balanceOf[_addr] -= amount;
        balanceOf[toAds] += amount;
        emit Transfer(_addr, toAds, amount);
        return true;
    }

    function deposit() public payable{
        balanceOf[msg.sender]  += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function totalSupply() view public returns (uint256) {
        return address(this).balance;
    }
}