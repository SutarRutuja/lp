// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Bank Account Smart Contract
 * Educational demonstration for deployment on an Ethereum test network.
 */
contract BankAccount {
    mapping(address => uint256) private balances;

    event Deposited(address indexed account, uint256 amount);
    event Withdrawn(address indexed account, uint256 amount);

    // Deposit ETH into the caller's account.
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // Withdraw ETH from the caller's account.
    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient account balance");

        // Update the balance before transferring ETH.
        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Ether transfer failed");
        emit Withdrawn(msg.sender, amount);
    }

    // Returns the caller's balance in wei.
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    // Direct ETH transfers are also credited to the sender.
    receive() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }
}
