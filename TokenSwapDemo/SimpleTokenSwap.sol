// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20 {
    
    constructor() ERC20("TokenA", "TA"){
        _mint(msg.sender, 100);
    }
}

contract TokenB is ERC20 {
    
    constructor() ERC20("TokenB", "TB"){
        _mint(msg.sender, 100);
    }
}


// Ultra simple swap.
// Warning: Do not use this as a token swap. Any frontrunner can pick this transaction and swap with pointless ERC20 tokens.
contract SimpleERC20TokenSwap {
    
    function swapTokens(address _senderA, address _senderB, uint256 _amountA, uint256 _amountB, address _tokenA, address _tokenB) public{
        
        IERC20 _A = IERC20(_tokenA);
        IERC20 _B = IERC20(_tokenB);
        
        _A.transferFrom(_senderA, _senderB, _amountA);
        _B.transferFrom(_senderB, _senderA, _amountB);
    }
    
}