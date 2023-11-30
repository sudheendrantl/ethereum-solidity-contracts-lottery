// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Lottery{
    enum statuscode {ACTIVE, INACTIVE}
    struct user{
        string username;
        address useraddress;
        uint usercontribution;
    }
    user[] private users;
    mapping (address=>user) private addrusermap;
    address payable private winner;
    address private admin;
    uint private usercount;
    uint private totalbalance;
    statuscode private status;

    constructor (){
        admin = msg.sender;
        status = statuscode.INACTIVE;
        addrusermap[address(0)]=user("None",address(0),0);
    }
    function register(string memory name) public usernotregistered payable {
        require(msg.sender!=address(0),"0 address not accepted");
        require(msg.value>0,"contribution cannot be 0");
        status = statuscode.ACTIVE;
        users.push(user({username:name, useraddress:msg.sender, usercontribution:msg.value}));
        addrusermap[msg.sender]=users[users.length-1];
        ++usercount;
        totalbalance+=msg.value;
    }
    function random(uint upperbound) private view returns (uint){
        return uint(keccak256(abi.encodePacked(block.timestamp))) % upperbound;
    }
    function resetgame() public adminonly{
        require(totalbalance==0 && status==statuscode.INACTIVE,"game is active");
        usercount = 0;
        status = statuscode.INACTIVE;
        totalbalance = 0;
        winner = payable (address (0));
        delete users;
        for (uint i; i<usercount;i++){
            delete addrusermap[users[i].useraddress];
        }
    }
    function selectwinner() public adminonly{
        require(status==statuscode.ACTIVE,"game is inactive");
        winner = payable (users[random(usercount)].useraddress);
        winner.transfer(totalbalance);
        totalbalance = 0;
        status = statuscode.INACTIVE;
    }
    function getAdminAdd() public view returns (address){
        return admin;
    }
    function getGameStatus() public view returns (string memory){
        return (status == statuscode.ACTIVE) ? "ACTIVE" : "INACTIVE";
    }
    function getUserContrib(address uaddress) public view returns (uint){
        return addrusermap[uaddress].usercontribution;
    }
    function getUserCount() public view returns (uint){
        return usercount;
    }
    function getUserName(address uaddress) public view returns (string memory){
        return addrusermap[uaddress].username;
    }
    function getWinnerAdd() public view returns (address){
        return winner;
    }
    function getWinnerName() public view returns (string memory){
        return addrusermap[winner].username;
    }
    function getWinningAmt() public view returns (uint){
        return totalbalance;
    }
    modifier adminonly {
        require(msg.sender==admin,"only admins can perform this action");
       _;
    }
    modifier usernotregistered(){
        for(uint i=0; i<usercount; i++){
            if(users[i].useraddress==msg.sender){
                require(false,"user already registered");
            }
        }
        _;
    }
}