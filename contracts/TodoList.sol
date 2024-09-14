// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract TodoList{
    struct todo {
        string name;
        bool isCompleted;
    }
    todo[] public list;
    function create(string memory name) external {
        list.push(todo(name,false));
    }
    function modiName(string memory name,uint256 index)  external {
        list[index].name = name;
    }
    function modiName2(string memory name,uint256 index)  external {
        // list[index].name = name;
        //先存储再修改，修改多个的时候比较省gas
        todo storage temp = list[index];
        temp.name = name;
    }
    function modiStatus(bool status,uint256 index)  external{
        list[index].isCompleted = status;
    }
    function toogleStatus(uint256 index)  external{
        list[index].isCompleted = !list[index].isCompleted;
    }

    function get1(uint256 index) public view  returns (string memory name,bool status) {
        todo memory temp = list[index];
        return (temp.name,temp.isCompleted);
    }
    // 获取任务2: storage : 1次拷贝
    function get2(uint256 index) public view  returns (string memory name,bool status) {
        todo storage temp = list[index];
        return (temp.name,temp.isCompleted);
    }
}

