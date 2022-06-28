//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract EtherWallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"Not an Owner!");
        _;
    }

    receive() external payable {}

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }    

    function withdraw(uint _amount) public payable onlyOwner {
        require(address(this).balance >= _amount, "Insufficient Balance");
        payable(msg.sender).transfer(_amount);
    }
}