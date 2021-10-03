// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import "./SimpleToken.sol";
import "./Pausable.sol";
import "./SafeMath.sol";

contract CrowedSale is Pausable {
    using SafeMath for uint256;


    uint256 public startTime;
    uint256 public endTime;

    uint256 public tokenPrice;
    uint256 public investmentObjective;
    
    mapping (address => uint256) public investmentAmountOf;

    uint256 public investmentReceived;
    uint256 public investmentRefunded;

    bool public isFinalized;
    bool public isRefundAllowed;

    SimpleToken public simpleToken;   

    event LogInvestment(address indexed investor, uint256 value);
    event LogTokenAssignment(address indexed investor, uint256 numTokens);
    event Refund(address investor, uint256 value);

    constructor(uint256 _startTime, uint256 _endTime, uint256 _weiTokenPrice, uint256 _weiInvestmentObjective) payable {
        
        require(_startTime >= block.timestamp);
        require(_endTime >= _startTime);
        
        require(_weiTokenPrice != 0);
        require(_weiInvestmentObjective != 0);
        
        startTime = _startTime;
        endTime = _endTime;
        
        tokenPrice = _weiTokenPrice;
        investmentObjective = _weiInvestmentObjective;

        simpleToken = new SimpleToken(0);
        isFinalized = false;
    }   

    function invest() public payable whenNotPaused {
        isValidInvestment(msg.value);

        address investor = msg.sender;
        uint256 value = msg.value;

        investmentAmountOf[investor] = investmentAmountOf[investor].add(value);
        investmentReceived = investmentReceived.add(value);

        assignTokens(value, investor);

        emit LogInvestment(investor, value);
    }

    function finalize() public onlyOwner {
        if(isFinalized) revert();

        bool timeFinished = block.timestamp >= endTime;
        bool fundCompleted = investmentReceived >= investmentObjective;

        if(timeFinished) {

            if(fundCompleted) {
                simpleToken.release();
            }
            else {
                isRefundAllowed = true;
            }

            isFinalized = true;
        }
    }

    function refund() public {
        if(!isRefundAllowed)
            revert();
        
        address payable investor = payable(msg.sender);
        uint256 investment = investmentAmountOf[investor];

        if(investment == 0) revert();

        investmentRefunded = investmentRefunded.add(investment);

        investmentAmountOf[investor] = 0;

        emit Refund(investor, investment);

        if(!investor.send(investment)) revert();
    }

    function isValidInvestment(uint256 _investment) internal view returns (bool) {
        
        bool nonZeroInvestment = _investment != 0;
        bool withinCrowdsalePeriod = block.timestamp >= startTime && block.timestamp <= endTime;
        
        return nonZeroInvestment && withinCrowdsalePeriod;
    }

    function assignTokens(uint256 _value, address _investor) internal {

        uint256 numberOfTokens = calculateTokens(_value);   

        simpleToken.mint(numberOfTokens, _investor);
    }

    function calculateTokens(uint256 _value) internal view returns (uint256) {
        return _value / tokenPrice;
    }
}