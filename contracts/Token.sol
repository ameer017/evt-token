// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Token {
    string public tokenName;
    string public tokenSymbol;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) allow;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    constructor() {
        tokenName = "Phoenix Gold";
        tokenSymbol = "POTUS";
        owner = msg.sender;
        //mint method
        mint(1_000_000, owner);
    }

   

    function balanceOf(address _address) public view returns (uint256) {
        return balances[_address];
    }

    function getTokenName() external view returns (string memory) {
        return tokenName;
    }

    function getSymbol() external view returns (string memory) {
        return tokenSymbol;
    }

    function getTotalSupply() external view returns (uint256) {
        return totalSupply;
    }

    function decimal() external pure returns (uint8) {
        return 18;
    }

    function transfer(address _reciever, uint256 _amountOfToken) external {
        require(_reciever != address(0), "Address is not allowed");

        require(
            _amountOfToken <= balances[msg.sender],
            "You can't take more than what is avaliable"
        );

        balances[msg.sender] -= _amountOfToken;

        balances[_reciever] = balances[_reciever] + _amountOfToken;

        emit Transfer(msg.sender, _reciever, _amountOfToken);
    }

    function approve(address _delegate, uint256 _amountOfToken) external {
        require(balances[msg.sender] > _amountOfToken, "Balance is not enough");

        allow[msg.sender][_delegate] = _amountOfToken;

        emit Approval(msg.sender, _delegate, _amountOfToken);
    }

    function burn(address _address, uint256 _amount) internal {
        balances[_address] = balances[_address] - _amount;
        totalSupply = totalSupply - _amount;

        emit Transfer(_address, address(0), _amount);
    }

    //method called in the constructor
    function mint(uint256 _amount, address _addr) internal {
        uint256 actualSupply = _amount * (10 ** 18);
        balances[_addr] = balances[_addr] + actualSupply;

        totalSupply = totalSupply + actualSupply;

        emit Transfer(address(0), _addr, actualSupply);
    }
}
