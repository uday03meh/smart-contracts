// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// task id,Category private
// change name to counter something
// taskid -- in deleteTask()
contract TodoList {
    uint256 public noOfPendingTasks;
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    struct TodoItem {
        string task;
        bool status;
        category Category;
    }

    enum category{
        web3,
        personal,
        college,
        others
    }

    category private Category = category.web3;

    uint256 private taskId = 0;
    mapping (uint256 => TodoItem) public List;
    
    // events are emitted by smart contracts and 
    // are used by frontend to update itself
    // frontend listens to those events
    event TaskCompleted(uint256 indexed id);
    // Creating an array "todos" of mappings
    // List[] public todos;

    function createTodo(string memory _task, category _Category) onlyOwner public {
        TodoItem memory item = TodoItem(_task, false, _Category);
        List[taskId] = item;
        // todos.push(List);
        taskId++;
        noOfPendingTasks++;
    }

    function markAsCompleted(uint256 _taskId) onlyOwner public {
        require(List[_taskId].status == false, "Task is already completed");
        List[_taskId].status = true;
        noOfPendingTasks--;
        emit TaskCompleted(_taskId);
    }

    function deleteTask(uint256 _taskId) public {
        delete List[_taskId];
        noOfPendingTasks--;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You cannot perform this action.");
        _;
    }
}
