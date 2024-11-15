// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract AccessControl {
    mapping(address => bool) public admins;

    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admins can call this function");
        _;
    }

    constructor() {
        admins[msg.sender] = true;
    }

    function addAdmin(address _admin) public onlyAdmin {
        admins[_admin] = true;
    }

    function removeAdmin(address _admin) public onlyAdmin {
        admins[_admin] = false;
    }
}
