// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;
    
contract Raffle {
    address public organizer;
    address[] public players;
    
    constructor(){
        organizer = msg.sender;
    }
    
    function enter() public payable{
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }
    
    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    function pickWinner() public payable{
        uint index = random() % players.length;
        payable(players[index]).transfer(address(this).balance);
    }
}