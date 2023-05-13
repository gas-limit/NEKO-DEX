// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "../interfaces/IERC20.sol";

contract stickyNotes {

    uint public totalDonated;


    struct stickyNote {
        address donor;
        uint amount;
        string message;
    }

    address immutable USDC_OPTIMISM_ADDRESS;

    address public FOUNDATION_ADDRESS;

    stickyNote[] allNotes;
    uint stickyCounter;

    constructor(address _token, address _FOUNDATION_ADDRESS){
        USDC_OPTIMISM_ADDRESS = _token;
        FOUNDATION_ADDRESS = _FOUNDATION_ADDRESS;
    }

    function newNote(uint _amount, string memory _message) public {
        require(_amount >= 5, "Minimum amount is $5");
        IERC20 USDC = IERC20(USDC_OPTIMISM_ADDRESS);
        _amount * 1 ether;

        USDC.transferFrom(msg.sender, FOUNDATION_ADDRESS, _amount);

        stickyNote memory newNote_ = stickyNote(msg.sender, _amount, _message);
        
        totalDonated += _amount;

        allNotes.push(newNote_);
    }


    function getAllMessages() public view returns (stickyNote[] memory){
        stickyNote[] memory tempNotes = allNotes;
        return tempNotes;
    }







    
}