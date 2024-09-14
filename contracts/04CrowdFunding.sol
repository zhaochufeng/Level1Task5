// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract CrowdFunding {
    address public immutable beneficiary;//受益人
    uint256 public immutable fundingGoal;//筹集项目基金
    uint256 public fundingAmount;//目前的项目资金总数
    mapping (address => uint256) funders;//记录参与筹集的人地址对应的捐款数
    mapping (address => bool) funderInserted;//参与筹集的人是否已经参与成功的表识
    bool public AVAILABLED = true;//不用自毁，通过变量来控制，当金额达到后，这个AVAILABLED置为false
    address[] fundkeys;

    //部署时候，写入受益人和项目资金筹集总数
    constructor(address beneficiary_,uint256 fundingAmount_) {
        beneficiary = beneficiary_;
        fundingAmount = fundingAmount_;
    }

    //进行捐献
    function contribute() external payable{
        require(AVAILABLED,"enough");
        uint256 potentialFundingAmount = fundingAmount + msg.value;
        uint256 refundAmount = 0;
        if (potentialFundingAmount > fundingGoal) {//超过目金额
            refundAmount = potentialFundingAmount - fundingAmount;
            funders[msg.sender] = msg.value - refundAmount;
            fundingAmount += (msg.value - refundAmount);
        }else{//inside target
            funders[msg.sender] = msg.value;
            fundingAmount += msg.value;
        }
        if (!funderInserted[msg.sender]) {
                funderInserted[msg.sender] = true;
                fundkeys.push(msg.sender);
        }
        //return excess money
        if (refundAmount > 0) {
           payable(msg.sender).transfer(refundAmount); 
        }
    }

    function close() external returns (bool) {
            // 1.检查
            if(fundingAmount<fundingGoal){
                return false;
            }
            uint256 amount = fundingAmount;
            fundingAmount = 0;
            payable(beneficiary).transfer(amount);
            AVAILABLED = false;
            return true;
        }
        
        function fundersLength() public view returns (uint256) {
            return fundkeys.length;
        }
}