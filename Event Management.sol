// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Contract {
    struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public Id = 0;

    function createEvent(string memory _name, uint _date, uint _price, uint _ticketCount) public {
        require(_date > block.timestamp, "You can't enter a event in past mf!");
        require(_ticketCount > 0, "All tickets are sold");
        events[Id] = Event(msg.sender, _name, _date, _price, _ticketCount);
        Id++;
        _ticketCount--;
    }

    function buyTicket(uint id, uint quantity) public payable{
        require(events[id].date != 0, "Event does not exist");
        require(events[id].date > block.timestamp, "Event has already occured");
        Event storage _event = events[id]; 
        require(msg.value == _event.price*quantity, "Aur paise dena baba!!!");
        require(_event.ticketCount > 0, "Sold out!");
        _event.ticketCount-= quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferTicket(uint id, address to, uint quantity) public{
        require(events[id].date != 0 && events[id].date > block.timestamp, "Event does not exist");
        require(events[id].date > block.timestamp, "Event has already occured");
        require(tickets[msg.sender][id] >= quantity);
        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }
}
