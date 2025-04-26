// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartConstitution {
    address public owner;
    string public constitution;
    string[] private constitutionHistory;
    mapping(address => bool) public members;
    address[] private memberList;

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
        constitutionHistory.push(initialConstitution);
        members[msg.sender] = true;
        memberList.push(msg.sender);
    }

    function updateConstitution(string memory newConstitution) public onlyOwner {
        constitution = newConstitution;
        constitutionHistory.push(newConstitution);
        emit ConstitutionUpdated(newConstitution);
    }

    function addMember(address newMember) public onlyOwner {
        require(!members[newMember], "Address is already a member.");
        members[newMember] = true;
        memberList.push(newMember);
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

    function getConstitutionHistory() public view returns (string[] memory) {
        return constitutionHistory;
    }

    function getTotalMembers() public view returns (uint256) {
        return memberList.length;
    }

    function getMembers(uint256 startIndex, uint256 count) public view returns (address[] memory) {
        require(startIndex < memberList.length, "Start index out of range");

        uint256 end = startIndex + count;
        if (end > memberList.length) {
            end = memberList.length;
        }

        address[] memory result = new address[](end - startIndex);
        for (uint256 i = startIndex; i < end; i++) {
            result[i - startIndex] = memberList[i];
        }

        return result;
    }

    // ---------------------------
    // New Functions Added Below
    // ---------------------------

    // Get the latest constitution version
    function getLatestConstitution() public view returns (string memory) {
        return constitution;
    }

    // Check if an address is part of the original signatories (first members)
    function isOriginalSigner(address addr) public view returns (bool) {
        return addr == memberList[0];
    }

    // Get the full list of all members (careful: could be large!)
    function getAllMembers() public view returns (address[] memory) {
        return memberList;
    }

    // Reset the constitution back to its original version
    function resetConstitution() public onlyOwner {
        require(constitutionHistory.length > 0, "No constitution history available.");
        constitution = constitutionHistory[0];
        constitutionHistory.push(constitution);
        emit ConstitutionUpdated(constitution);
    }

    // Remove all members except the owner
    function removeAllMembers() public onlyOwner {
        for (uint256 i = 0; i < memberList.length; i++) {
            address member = memberList[i];
            if (member != owner) {
                members[member] = false;
                emit MemberRemoved(member);
            }
        }
        // Reset member list to only include the owner
        delete memberList;
        memberList.push(owner);
    }
}
