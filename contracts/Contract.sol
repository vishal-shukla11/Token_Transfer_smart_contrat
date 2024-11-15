// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenContract {
    address public owner;
    mapping(address => uint256) public balances;

    // Event to log transfers
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Modifier to restrict functions to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
    }

    // Function to transfer tokens, restricted to the owner
    function transfer(address _to, uint256 _amount) public onlyOwner {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_to != address(0), "Invalid address");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        // Emit transfer event
        emit Transfer(msg.sender, _to, _amount);
    }

    // Function to mint new tokens to an account (for testing purposes)
    function mint(address _to, uint256 _amount) public onlyOwner {
        require(_to != address(0), "Invalid address");
        balances[_to] += _amount;
    }

    // Function to get balance of a specific address
    function balanceOf(address _account) public view returns (uint256) {
        return balances[_account];
    }
}
