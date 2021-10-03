// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

contract Owner {
    
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function setOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        
        owner = newOwner;
    }
}