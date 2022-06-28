//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract TimeLock {

    uint public immutable TIME_LOCK;

    address public owner;
    mapping(address => uint) public balanceOf;
    mapping(address => uint) public timeLock;

    constructor(uint _timeLock) {
        owner = msg.sender;
        TIME_LOCK = _timeLock;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner!");
        _;
    }

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
        timeLock[msg.sender] = block.timestamp + TIME_LOCK;
    }

    function withdraw(uint _amount) external {
        require(block.timestamp >= timeLock[msg.sender], "Withdrawal Failed. Fund currently Locked.");
        require(balanceOf[msg.sender] >= _amount, "Not enough balance to withdraw.");

        balanceOf[msg.sender] -= _amount;

        (bool success, ) = msg.sender.call{value: _amount}("");
        if (!success) {
            balanceOf[msg.sender] += _amount;
            revert("Transaction Failed");
        }
    }

    function increaseLockTime(address _addr, uint _timeIncrease) public onlyOwner {
        require(block.timestamp <= timeLock[msg.sender], "TimeLock Expired!");
        timeLock[_addr] += _timeIncrease;
    } 
}