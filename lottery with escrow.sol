// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Lottery{
    address[] private players;
    address payable private escrow;
    uint constant lottery_cost = 1000000;
    uint balance;

    function registerEscrow() public payable{
        escrow = payable(msg.sender);
        balance= 0;
    }
    function registerPlayer() public payable {
        require(escrow!=address(0), "no escrow registered");
        require(msg.sender!=escrow, "escrow cannot be a player");
        require(msg.value>=lottery_cost, "insufficient amount");
        escrow.transfer(lottery_cost);
        balance+=lottery_cost;
        players.push(msg.sender);
    }
    function drawWinner() public payable {
        require(msg.sender==escrow, "only the escrow can draw");
        require(players.length > 0, "no players in game");
        payable(players[uint(keccak256(abi.encodePacked(block.timestamp)))%players.length]).transfer(balance);
        delete players;
    }
    function status() public view returns (string memory){
        return (players.length > 0) ? "ACTIVE" : "INACTIVE";
    }
    function playerCount() public view returns (uint){
        return players.length;
    }
}