// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "../interfaces/IERC20.sol";

contract stickyNotes {


    struct stickyNote {
        address donor;
        uint amount;
        string message;
    }

    address constant USDC_OPTIMISM_ADDRESS = 0x7F5c764cBc14f9669B88837ca1490cCa17c31607;

    address public FOUNDATION_ADDRESS;

    stickyNote[] allNotes;
    uint stickyCounter;

    function newNote(uint _amount, string memory _message) public {
        /*require(_amount >= 5, "Minimum amount is $5");
        IERC20 USDC = IERC20(USDC_OPTIMISM_ADDRESS);
        _amount * 1 ether;

        USDC.transferFrom(msg.sender, address(this), _amount);
        */

        stickyNote memory newNote_ = stickyNote(msg.sender, _amount, _message);

        allNotes.push(newNote_);

    }

    //send donation to foundation wallet
    function sendDonations() public returns (uint) {
        IERC20 USDC = IERC20(USDC_OPTIMISM_ADDRESS);  
        uint amount = USDC.balanceOf(address(this));    
        USDC.approve(FOUNDATION_ADDRESS, amount );
        USDC.transfer(FOUNDATION_ADDRESS, amount);
        return amount; 
    }

    function getAllDonors() public view returns (address[] memory){
        stickyNote[] memory tempNotes = allNotes;
        address[] memory addresses;
        uint numNotes = tempNotes.length;

        for(uint i; i < numNotes; i++){
            addresses[i] = tempNotes[i].donor;
        }

        return addresses;

    }

    function getAllAmounts() public view returns (uint[] memory){
        stickyNote[] memory tempNotes = allNotes;
        uint[] memory amounts;
        uint numNotes = tempNotes.length;

        for(uint i; i < numNotes; i++){
            amounts[i] = tempNotes[i].amount;
        }

        return amounts;

    }


    function getAllMessages() public view returns (string[] memory){
        stickyNote[] memory tempNotes = allNotes;
        string[] memory messages;
        uint numNotes = tempNotes.length;

        for(uint i; i < numNotes; i++){
            messages[i] = tempNotes[i].message;
        }

        return messages;

    }





    
}
