// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Pausable.sol";
import "./SafeMath.sol";

contract SimpleToken is Pausable {
    using SafeMath for uint256;

    string public name = "DemoCoin";
    string public symbol = "DEC";
    string public standard = "Demo coin v1.0";
    
    uint256 public totalSupply;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 _initialSupply){
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
        paused = true;
    }

    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function mint(uint256 value, address receiver) public onlyOwner {
        require(receiver != address(0));

        balanceOf[receiver] = balanceOf[receiver].add(value);
        totalSupply = totalSupply.add(value);
    }

    function release() public onlyOwner {
        unPause();
    }
}