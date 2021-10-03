// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import "./Owner.sol";

contract Pausable is Owner {
    bool public paused = false;

    modifier whenPaused() {
        require(paused);
        _;
    }

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    function pause() public onlyOwner whenNotPaused {
        paused = true;
    }

    function unPause() public onlyOwner whenPaused{
        paused = false;
    }
}