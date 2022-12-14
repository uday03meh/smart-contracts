// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// task id,Category private
// change name to counter something
// taskid -- in deleteTask()
contract ToDoList2 {

    event AddTask(address recipient, uint256 taskId);
    event CompleteTask(uint256 taskId, bool isCompleted);

    // mimics an object in javascript
    struct Task{
        uint taskId;
        string taskText;
        bool isCompleted;
    }

    // array "tasks" of struct "Task"
    Task[] private tasks;

// tasks = [
// { id: 0, taskText: 'clean', isCompleted: false },
// { id: 1, taskText: 'clean', isCompleted: false },
// { id: 2, taskText: 'clean', isCompleted: false }


// helps in deciding which task belongs to which address
    mapping(uint256 => address) taskToOwner;

    function addTask(string memory _taskText) external{
        uint256 _taskId = tasks.length; // length on array
        tasks.push(Task(_taskId, _taskText, false));
        taskToOwner[_taskId] = msg.sender;
        emit AddTask(msg.sender, _taskId);
    }

// get not completed tasks
    function getTasks() external view returns(Task[] memory){
        uint256 counter = 0;
        Task[] memory temporary = new Task[](tasks.length);
        for(uint256 i = 0; i < tasks.length; i++){
            if(taskToOwner[i] == msg.sender && tasks[i].isCompleted == false){
                temporary[counter] = tasks[i];
                counter++;
            }
        }
        // Task[] memory result = new Task[](temporary.length);
        // for(uint256 j = 0; j < temporary.length; j++){
        //     result[j] = temporary
        // }
        return temporary;
    }

    function completeTask(uint256 _taskId) external {
        require(taskToOwner[_taskId] == msg.sender, "You don't have access to view these tasks");
        tasks[_taskId].isCompleted = true; 
        emit CompleteTask(_taskId, true);
    }
}
