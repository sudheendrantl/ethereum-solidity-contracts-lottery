// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Lottery{
    address[] private players;
    function registerPlayer() public payable {
        require(msg.value>0, "value should be >0");
        players.push(msg.sender);
    }
    function drawWinner() public payable {
        payable(players[uint(keccak256(abi.encodePacked(block.timestamp)))%players.length]).transfer(address(this).balance);
        delete players;
    }
    function status() public view returns (string memory){
        return (players.length > 0) ? "ACTIVE" : "INACTIVE";
    }
    function playerCount() public view returns (uint){
        return players.length;
    }
}