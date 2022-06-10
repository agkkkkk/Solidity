//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract TodoList {
    struct Todo {
        string task;
        bool status;
    }

    Todo[] public todos;

    function createTask(string memory _task) public {
        todos.push(Todo({
            task: _task,
            status: false
        }));
    }

    function updateTask(uint _index, string memory _task) public {
        todos[_index].task = _task;
    }

    function getTodo(uint _index) public view returns (string memory task, bool status) {
        Todo memory todo = todos[_index];
        return (todo.task, todo.status);
    }

    function toggleStatus(uint _index) public {
        todos[_index].status = !todos[_index].status;
    } 
}