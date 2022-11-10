// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    } 

    receive() external payable {
        require(msg.value == 50000000000000000, "You need to pay 0.05 ETH to buy a ticket!");
        // Price of ticket = 0.05 ETH, any transaction to contract less than that is failed
        participants.push(payable(msg.sender));
        // msg.sender by-default has type 'address', to make sure we can transfer 
        // winning amount to this address later, we make it 'address payable' type
        // adding address of accounts to array which make the transaction to contract
    }

// function to get contract's balance
// .this points to the contract
    function getBalance() public view returns(uint){
        require(msg.sender == manager, "You do not have access to this function.");
        return address(this).balance;
    }

    function random() public view returns(uint) {
        // generates a random number
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint index = random() % participants.length;
        participants[index].transfer((address(this)).balance);
        participants = new address payable[](0);
    }
}
