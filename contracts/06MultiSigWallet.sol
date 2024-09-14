// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract MultiSigWallet {
    address[] public owners;
    mapping (address=>bool) public isOwner;
    uint256 public required;
    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool exected;
    }
    Transaction[] public transactions;
    mapping (uint256=>mapping (address=>bool)) public approved;
    // event
    event Deposit(address indexed sender,uint256 amount);
    event Submit(uint256 indexed txId);
    event Approve(address indexed owner,uint256 indexed txId);
    event Revoke(address indexed owner,uint256 indexed txId);
    event Execute(uint256 indexed txId);

    //receive
    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }

    //modifier
    modifier onlyOwner(){
        require(isOwner[msg.sender],"not owner!");
        _;
    }
    modifier txExists(uint256 _txId){
        require(_txId < transactions.length,"tx doesn't exist!");
        _;
    }
    modifier notApproved(uint256 _txId){
        require(!approved[_txId][msg.sender],"tx already approved!");
        _;
    }
    modifier notExecuted(uint256 _txId){
        require(!transactions[_txId].exected,"tx is executed!");
        _;
    }
    //constructor
    constructor(address[] memory _owners,uint256 _required) {
        require(owners.length > 0,"owner required");
        require(
            _required > 0 && _required <= owners.length,
            "invalid required number of owners"
        );
        for (uint256 index = 0; index < owners.length; index++) {
            address owner = _owners[index];
            require(owner != address(0),"invalid owner");
            require(!isOwner[owner],"owner is not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }

    //function 
    function getBalance() view external returns (uint256) {
        return address(this).balance;
    }
    function sumbmit(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyOwner returns (uint256) {
        transactions.push(
            Transaction({to:_to,value:_value,data:_data,exected:false})
        );
        emit Submit(transactions.length-1);
        return transactions.length - 1;
    }
    function approv(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notApproved(_txId)
        notExecuted(_txId)
    {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);   
    }
    function execute(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        
    }
    function getApprovalCount(uint256 _txId) 
        public
        view
        returns(uint256 count)
    {
        for (uint256 index = 0; index < owners.length; index++) {
            if (approved[_txId][owners[index]]) {
                count += 1;
            }
        }
    }
    function revoke(uint256 _txId) 
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        require(approved[_txId][msg.sender],"tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);   
    }
}