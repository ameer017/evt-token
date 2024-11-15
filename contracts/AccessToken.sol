// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "./Token.sol";
import "./AccessControl.sol";

contract AccessControlledToken is Token, AccessControl {
    function mint(address to, uint256 value) public onlyAdmin {
        totalSupply += value;
        balances[to] += value;
        emit Transfer(address(0), to, value);
    }
}
