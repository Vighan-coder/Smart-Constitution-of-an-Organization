// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartConstitution {
    address public owner;
    string public constitution;
    mapping(address => bool) public members;

    event ConstitutionUpdated(string newConstitution);
    event MemberAdded(address member);
    event MemberRemoved(address member);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

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
        require(!members[newMember], "Address is already a member.");
        members[newMember] = true;
        emit MemberAdded(newMember);
    }

    function removeMember(address member) public onlyOwner {
        require(members[member], "Address is not a member.");
        members[member] = false;
        emit MemberRemoved(member);
    }

    function isMember(address addr) public view returns (bool) {
        return members[addr];
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address.");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}


