// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartConstitution {
    address public owner;
    string public constitution;
    mapping(address => bool) public members;

    event ConstitutionUpdated(string newConstitution);
    event MemberAdded(address member);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    }

    constructor(string memory initialConstitution) {
        owner = msg.sender;
        constitution = initialConstitution;
        members[msg.sender] = true;
    }

    function updateConstitution(string memory newConstitution) public onlyOwner {
        constitution = newConstitution;
        emit ConstitutionUpdated(newConstitution);
    }

    function addMember(address newMember) public onlyOwner {
        members[newMember] = true;
        emit MemberAdded(newMember);
    }
}

