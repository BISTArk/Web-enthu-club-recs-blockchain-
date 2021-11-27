pragma solidity ^0.8.0;

contract GymRental{
    
    address payable public owner;
    uint rentTime;
    uint public log;
    
    struct Mach{
        uint price;
        address _owns;
        uint issuedTime;
    }
    
    mapping(string=>Mach) public machines;
    
    uint public noMachs = 0;
    
    constructor() public payable{
        owner = payable(msg.sender);
        rentTime = 1800;
        log = (address(this).balance);
    }
    
    modifier isOwner(){
        require(msg.sender==owner,"Only the owner can access this");
        _;
    }
    
    modifier isAvail(string memory _name){
        require(machines[_name].issuedTime<=block.timestamp,"Machine is in use now");
        _;
    }
    
    modifier notNull(string memory _name){
        require(machines[_name]._owns!=address(0),"No such Machine is Available");
        _;
    }
    
    modifier noLess(string memory _name, uint val){
        require(val>=machines[_name].price,"Give more money");
        _;
    }
    
    function addMach(string memory _name,uint price) public isOwner{
        
        machines[_name] = Mach(price,owner,0);
        noMachs ++;
    }
    
    function removeMach(string memory _name) public isOwner notNull(_name){
        delete machines[_name];
        noMachs --;
    }    
    
    function setPrice(string memory _name,uint x) public isOwner notNull(_name){
        machines[_name].price = x;
    }
    
    function rent(string memory _name) public payable isAvail(_name) noLess(_name,msg.value) notNull(_name){
        machines[_name]._owns = msg.sender;
        machines[_name].issuedTime = block.timestamp + rentTime;
        log = (address(this).balance);
    }
    
    function whoHas(string memory _name) public notNull(_name) returns(address){
        address x = machines[_name]._owns;
        return x;
    }
    
    function withdraw() public isOwner{
        uint amount = address(this).balance;

        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }
    
    
}