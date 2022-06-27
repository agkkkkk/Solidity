//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract VendingMachine {
    address public operator;

    mapping(address => uint) public itemBalance;

    constructor(uint _itemAmount) {
        operator = msg.sender;
        itemBalance[address(this)] = _itemAmount;
    }

    modifier onlyOperator() {
        require(msg.sender == operator, "Not a valid Operator.");
        _;
    }

    function buy(uint _amount) public payable {
        require(msg.value >= _amount * 2 ether,"Not enough Ether sent.");
        itemBalance[address(this)] -= _amount;
        itemBalance[msg.sender] += _amount;
    }

    function reStock(uint _amount) public onlyOperator {
        itemBalance[address(this)] += _amount;
    }

    function withdraw() public onlyOperator {
        payable(msg.sender).transfer(address(this).balance);
    }
}