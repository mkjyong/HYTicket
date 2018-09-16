pragma solidity ^0.4.18;

contract hiTicket {

    event ticketAuth(ticket);
    event ticketingStart(uint);

    struct ticket {
        uint x_seat;
        uint y_seat;
    }

    struct concert{
        address concertOwner;
        string name;
        string location;
        string time;
        string startDate;
        string endDate;
        bool progress;
        mapping (uint => uint) limits; // 각열에 몇개의 좌석이 있는지
        mapping (uint => mapping(uint => bool)) occupied;
        mapping (string => ticket) pNumToTicket;
    }

    concert[] concerts;


    constructor(address _owner,string _name, string _location,
     string _time, string _startDate, string _endDate,uint xCount, uint[] yCount) public {

        uint id = concerts.push(concert(_owner,_name, _location, _time, _startDate, _endDate, true))-1;
        for(uint i = 0 ; i < xCount ; i++){
            concerts[id].limits[xCount] = yCount[i];
        }
        emit ticketingStart(id);
    }

    function ticketBuying(uint _concertId,uint _x_seat, uint _y_seat, string _pNum) public {
        require(!concerts[_concertId].occupied[_x_seat][_y_seat], "This seat is Occupied");
        require(concerts[_concertId].progress, "This concert ticketing End");

        concerts[_concertId].pNumToTicket[_pNum] = ticket(_x_seat,_y_seat);
        concerts[_concertId].occupied[_x_seat][_y_seat] = true;
        emit ticketAuth(ticket(_x_seat,_y_seat));
    }

    function payment(uint _concertId,uint _money) public {
        concerts[_concertId].concertOwner.transfer(_money);
    }

    function ticketEnd(uint _concertId) public {
        require(msg.sender == concerts[_concertId].concertOwner, "You can't do it");
        concerts[_concertId].progress = false;
    }

    function sendTicket(uint _concertId,string _pNum) public view returns(uint,uint) {
        return (concerts[_concertId].pNumToTicket[_pNum].x_seat,concerts[_concertId].pNumToTicket[_pNum].y_seat);
    }
}
