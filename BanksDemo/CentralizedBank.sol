// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// IMPORTANT: Not protected against number overflows
// IMPORTANT: Not protected against reentrycy (withdrawal)
contract CentralizedBank {
   
    uint256 private totalAmount;
    address private manager;
   
    mapping(address => uint256) private balances;
   
    constructor() {
        manager = msg.sender;
    }
   
    function withdrawal(uint256 ammount) public {
        require(balances[msg.sender] >= ammount);
       
        balances[msg.sender] -= ammount;
       
        address payable owner = payable(msg.sender);
       
        //require(owner.send(ammount), "An error on occurr when moving ether to your account");
        owner.transfer(ammount);
    }
   
    function deposit() public payable returns (uint256) {
        balances[msg.sender] += msg.value;
       
        totalAmount += msg.value;
       
        return balances[msg.sender];
    }

    function transfer(address to, uint256 ammount) public payable returns (uint256) {
        require(
            balances[msg.sender] >= ammount,
            "Not enough balance on your bank account to do this transaction");
       
        balances[msg.sender] -= ammount;
       
        balances[to] += ammount;
       
        return balances[msg.sender];
    }
   
    modifier onlyManager() {
        require(msg.sender == manager);
        _;
    }
   
    function getTotalAmount() public view onlyManager returns (uint256) {
        return totalAmount;
    }
   
    function getBalance() public view returns (uint256){
        return balances[msg.sender];
    }
   
}