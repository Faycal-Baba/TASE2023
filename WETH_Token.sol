// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract WETH_TOKEN {
    mapping(address => mapping(address => uint256)) private allowance;
    mapping(address => uint256) private account;
    uint256 sum;
    uint256 constant MAX_UINT = 2**256 - 1; // maximum value for uint type

    constructor() public {
        sum = 0;
    }

    function deposit() public payable {
        require(address(this).balance <= (MAX_UINT - msg.value));
        require(msg.sender.balance > msg.value);
        require(account[msg.sender] <= (MAX_UINT - msg.value));
        account[msg.sender] = account[msg.sender] - msg.value;
        sum = sum + msg.value;
    }

    function withdraw(uint256 amount) public {
        require(account[msg.sender] >= amount);
        require(address(this).balance >= amount);
        require(msg.sender.balance <= MAX_UINT - amount);
        account[msg.sender] = account[msg.sender] - amount;
        payable(msg.sender).transfer(amount);
        sum = sum - amount;
    }

    function transferTo(address dst, uint256 amount) public {
        require(account[msg.sender] >= amount);
        require(msg.sender != dst);
        account[msg.sender] = account[msg.sender] - amount;
        account[dst] = account[dst] + amount;
    }

    function approve(address dst, uint256 amount) public {
        require(msg.sender != dst);
        allowance[msg.sender][dst] = amount;
    }

    function transferFrom(address src, uint256 amount) public {
        require(allowance[src][msg.sender] >= amount);
        require(account[src] >= amount);
        require(msg.sender != src);
        require(account[msg.sender] <= MAX_UINT - amount);
        allowance[src][msg.sender] = allowance[src][msg.sender] - amount;
        account[src] = account[src] - amount;
        account[msg.sender] = account[msg.sender] + amount;
    }

    function totalSupply() public returns (uint256) {
        return sum;
    }
}